import { Request, Response } from "express"
import multer from "multer"
import multerConfig from "../utils/multer_config"
import connection from "../utils/db"

const upload = multer(multerConfig.config).single(multerConfig.keyUpload)

/**
 * @swagger
 * /api/products:
 *   get:
 *     tags:
 *       - Products
 *     summary: Get all products
 *     description: Retrieve a list of all products
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of products
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Product'
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
function getAllProducts(req: Request, res: Response) {
  try {
    connection.execute(
      "SELECT * FROM products ORDER BY id DESC",
      function (err, results) {
        if (err) {
          res.json({ status: "error", message: err });
          return;
        } else {
          res.json(results);
        }
      }
    );
  } catch (err) {
    console.error("Error storing product in the database: ", err);
    res.sendStatus(500);
  }
}

/**
 * @swagger
 * /api/products/{productId}:
 *   get:
 *     tags:
 *       - Products
 *     summary: Get product by ID
 *     description: Retrieve a specific product by its ID
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: productId
 *         required: true
 *         schema:
 *           type: integer
 *         description: Product ID
 *     responses:
 *       200:
 *         description: Product details
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Product'
 *       401:
 *         description: Unauthorized
 *       404:
 *         description: Product not found
 *       500:
 *         description: Internal server error
 */
function getProductById(req: Request, res: Response) {
  try {
    connection.execute(
      "SELECT * FROM products WHERE id = ?",
      [req.params.productId],
      function (err, results) {
        if (err) {
          res.json({ status: "error", message: err })
          return
        } else {
          res.json(results)
        }
      }
    )
  } catch (err) {
    console.error("Error storing product in the database: ", err)
    res.sendStatus(500)
  }
}

/**
 * @swagger
 * /api/products:
 *   post:
 *     tags:
 *       - Products
 *     summary: Create a new product
 *     description: Create a new product with optional image upload
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - description
 *               - barcode
 *               - stock
 *               - price
 *               - category_id
 *               - user_id
 *               - status_id
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               barcode:
 *                 type: string
 *               image:
 *                 type: string
 *                 format: binary
 *               stock:
 *                 type: integer
 *               price:
 *                 type: number
 *               category_id:
 *                 type: integer
 *               user_id:
 *                 type: integer
 *               status_id:
 *                 type: integer
 *     responses:
 *       200:
 *         description: Product created successfully
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
 *                 product:
 *                   $ref: '#/components/schemas/Product'
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
function createProduct(req: Request, res: Response) {
  upload(req, res, async (err) => {
    if (err instanceof multer.MulterError) {
      console.log(`error: ${JSON.stringify(err)}`)
      return res.status(500).json({ message: err })
    } else if (err) {
      console.log(`error: ${JSON.stringify(err)}`)
      return res.status(500).json({ message: err })
    } else {
      // console.log(`file: ${JSON.stringify(req.file)}`)
      // console.log(`body: ${JSON.stringify(req.body)}`)
      try {
        const {
          name,
          description,
          barcode,
          stock,
          price,
          category_id,
          user_id,
          status_id,
        } = req.body
        const image = req.file ? req.file.filename : null
        console.log(req.file)
        connection.execute(
          "INSERT INTO products (name, description, barcode, image, stock, price, category_id, user_id, status_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [
            name,
            description,
            barcode,
            image,
            stock,
            price,
            category_id,
            user_id,
            status_id,
          ],
          function (err, results: any) {
            if (err) {
              res.json({ status: "error", message: err })
              return
            } else {
              res.json({
                status: "ok",
                message: "Product created successfully",
                product: {
                  id: results.insertId,
                  name: name,
                  description: description,
                  barcode: barcode,
                  image: image,
                  stock: stock,
                  price: price,
                  category_id: category_id,
                  user_id: user_id,
                  status_id: status_id,
                },
              })
            }
          }
        )
      } catch (err) {
        console.error("Error storing product in the database: ", err)
        res.sendStatus(500)
      }
    }
  })
}

/**
 * @swagger
 * /api/products/{productId}:
 *   put:
 *     tags:
 *       - Products
 *     summary: Update a product
 *     description: Update an existing product with optional image upload
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: productId
 *         required: true
 *         schema:
 *           type: integer
 *         description: Product ID
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - description
 *               - barcode
 *               - stock
 *               - price
 *               - category_id
 *               - user_id
 *               - status_id
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               barcode:
 *                 type: string
 *               image:
 *                 type: string
 *                 format: binary
 *               stock:
 *                 type: integer
 *               price:
 *                 type: number
 *               category_id:
 *                 type: integer
 *               user_id:
 *                 type: integer
 *               status_id:
 *                 type: integer
 *     responses:
 *       200:
 *         description: Product updated successfully
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
 *                 product:
 *                   $ref: '#/components/schemas/Product'
 *       401:
 *         description: Unauthorized
 *       404:
 *         description: Product not found
 *       500:
 *         description: Internal server error
 */
function updateProduct(req: Request, res: Response) {
  upload(req, res, async (err) => {
    if (err instanceof multer.MulterError) {
      console.log(`error: ${JSON.stringify(err)}`)
      return res.status(500).json({ message: err })
    } else if (err) {
      console.log(`error: ${JSON.stringify(err)}`)
      return res.status(500).json({ message: err })
    } else {
      console.log(`file: ${JSON.stringify(req.file)}`)
      console.log(`body: ${JSON.stringify(req.body)}`)
      try {
        const {
          name,
          description,
          barcode,
          stock,
          price,
          category_id,
          user_id,
          status_id,
        } = req.body
        const image = req.file ? req.file.filename : null
        // console.log(req.file)

        let sql =
          "UPDATE products SET name = ?, description = ?, barcode = ?, stock = ?, price = ?, category_id = ?, user_id = ?, status_id = ? WHERE id = ?"
        let params = [
          name,
          description,
          barcode,
          stock,
          price,
          category_id,
          user_id,
          status_id,
          req.params.productId,
        ]

        if (image) {
          sql =
            "UPDATE products SET name = ?, description = ?, barcode = ?, image = ?, stock = ?, price = ?, category_id = ?, user_id = ?, status_id = ? WHERE id = ?"
          params = [
            name,
            description,
            barcode,
            image,
            stock,
            price,
            category_id,
            user_id,
            status_id,
            req.params.productId,
          ]
        }

        connection.execute(sql, params, function (err) {
          if (err) {
            res.json({ status: "error", message: err })
            return
          } else {
            res.json({
              status: "ok",
              message: "Product updated successfully",
              product: {
                id: req.params.productId,
                name: name,
                description: description,
                barcode: barcode,
                image: image,
                stock: stock,
                price: price,
                category_id: category_id,
                user_id: user_id,
                status_id: status_id,
              },
            })
          }
        })
      } catch (err) {
        console.error("Error storing product in the database: ", err)
        res.sendStatus(500)
      }
    }
  })
}

/**
 * @swagger
 * /api/products/{productId}:
 *   delete:
 *     tags:
 *       - Products
 *     summary: Delete a product
 *     description: Delete an existing product by ID
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: productId
 *         required: true
 *         schema:
 *           type: integer
 *         description: Product ID
 *     responses:
 *       200:
 *         description: Product deleted successfully
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
 *                 product:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *       401:
 *         description: Unauthorized
 *       404:
 *         description: Product not found
 *       500:
 *         description: Internal server error
 */
function deleteProduct(req: Request, res: Response) {
  try {
    connection.execute(
      "DELETE FROM products WHERE id = ?",
      [req.params.productId],
      function (err) {
        if (err) {
          res.json({ status: "error", message: err })
          return
        } else {
          res.json({
            status: "ok",
            message: "Product deleted successfully",
            product: {
              id: req.params.productId,
            },
          })
        }
      }
    )
    // Delete file from server
    const fs = require("fs")
    const path = require("path")
    const filePath = path.join(
      __dirname,
      "../public/uploads/",
      req.params.productId
    )
  } catch (err) {
    console.error("Error storing product in the database: ", err)
    res.sendStatus(500)
  }
}

export {
  getAllProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
}
