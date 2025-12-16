import jwt from "jsonwebtoken"
import bcrypt from "bcrypt"
import { Request, Response } from "express"
import connection from "../utils/db"

// Define types for the user inputs
interface UserInput {
  firstname: string
  lastname: string
  email: string
  password: string
}

/**
 * @swagger
 * /api/auth/register:
 *   post:
 *     tags:
 *       - Authentication
 *     summary: Register a new user
 *     description: Create a new user account
 *     security: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - firstname
 *               - lastname
 *               - email
 *               - password
 *             properties:
 *               firstname:
 *                 type: string
 *                 example: John
 *               lastname:
 *                 type: string
 *                 example: Doe
 *               email:
 *                 type: string
 *                 format: email
 *                 example: john@example.com
 *               password:
 *                 type: string
 *                 format: password
 *                 example: password123
 *     responses:
 *       200:
 *         description: User registered successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: ok
 *                 message:
 *                   type: string
 *                   example: User registered successfully
 *                 token:
 *                   type: string
 *                 user:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         description: Email already exists
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 */
async function register(req: Request, res: Response): Promise<void> {
  const { firstname, lastname, email, password }: UserInput = req.body

  // Check if the user already exists
  try {
    connection.execute(
      "SELECT * FROM users WHERE email = ?",
      [email],
      function (err, results: any, fields) {
        if (err) {
          res.json({ status: "error", message: err })
          return
        } else {
          if (results.length > 0) {
            res.json({ status: "error", message: "Email already exists" })
            return
          } else {
            // Hash the password
            bcrypt.hash(password, 10, function (err, hash) {
              if (err) {
                res.json({ status: "error", message: err })
                return
              } else {
                // Store the user in the database
                const query =
                  "INSERT INTO users (firstname, lastname, email, password, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())"
                const values = [firstname, lastname, email, hash]

                // Insert the new user into the database
                connection.execute(
                  query,
                  values,
                  function (err, results: any, fields) {
                    if (err) {
                      res.json({ status: "error", message: err })
                      return
                    } else {
                      // Generate JWT token for the registered user
                      const token = jwt.sign(
                        { email },
                        process.env.JWT_SECRET || ""
                      )

                      res.json({
                        status: "ok",
                        message: "User registered successfully",
                        token: token,
                        user: {
                          id: results.insertId,
                          firstname: firstname,
                          lastname: lastname,
                          email: email,
                        },
                      })
                    }
                  }
                )
              }
            })
          }
        }
      }
    )
  } catch (err) {
    console.error("Error storing user in the database: ", err)
    res.sendStatus(500)
  }
}

/**
 * @swagger
 * /api/auth/login:
 *   post:
 *     tags:
 *       - Authentication
 *     summary: Login user
 *     description: Authenticate user and get JWT token
 *     security: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: john@example.com
 *               password:
 *                 type: string
 *                 format: password
 *                 example: password123
 *     responses:
 *       200:
 *         description: User logged in successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: ok
 *                 message:
 *                   type: string
 *                   example: User logged in successfully
 *                 token:
 *                   type: string
 *                 user:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         description: Invalid credentials
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 */
async function login(req: Request, res: Response): Promise<void> {
  const { email, password }: UserInput = req.body

  try {
    connection.execute(
      "SELECT * FROM users WHERE email = ?",
      [email],
      function (err, results: any, fields) {
        if (err) {
          res.json({ status: "error", message: err })
          return
        } else {
          if (results.length > 0) {
            // Compare the password with the hash
            bcrypt.compare(
              password,
              results[0].password,
              function (err, result) {
                if (err) {
                  res.json({ status: "error", message: err })
                  return
                } else {
                  if (result) {
                    // Generate JWT token for the registered user
                    const token = jwt.sign(
                      { email },
                      process.env.JWT_SECRET || ""
                    )

                    res.json({
                      status: "ok",
                      message: "User logged in successfully",
                      token: token,
                      user: {
                        id: results[0].id,
                        firstname: results[0].firstname,
                        lastname: results[0].lastname,
                        email: results[0].email,
                      },
                    })
                  } else {
                    res.json({
                      status: "error",
                      message: "Email and password does not match",
                    })
                    return
                  }
                }
              }
            )
          } else {
            res.json({ status: "error", message: "Email does not exists" })
            return
          }
        }
      }
    )
  } catch (err) {
    console.error("Error querying the database: ", err)
    res.sendStatus(500)
  }
}

export { register, login }
