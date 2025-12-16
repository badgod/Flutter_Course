import swaggerJsdoc from 'swagger-jsdoc'

const options: swaggerJsdoc.Options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Server API Documentation',
      version: '1.0.0',
      description: 'API documentation for Server API with authentication and product management',
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
      schemas: {
        User: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              description: 'User ID',
            },
            firstname: {
              type: 'string',
              description: 'User first name',
            },
            lastname: {
              type: 'string',
              description: 'User last name',
            },
            email: {
              type: 'string',
              format: 'email',
              description: 'User email address',
            },
          },
        },
        Product: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              description: 'Product ID',
            },
            name: {
              type: 'string',
              description: 'Product name',
            },
            description: {
              type: 'string',
              description: 'Product description',
            },
            barcode: {
              type: 'string',
              description: 'Product barcode',
            },
            image: {
              type: 'string',
              nullable: true,
              description: 'Product image filename',
            },
            stock: {
              type: 'integer',
              description: 'Product stock quantity',
            },
            price: {
              type: 'number',
              format: 'float',
              description: 'Product price',
            },
            category_id: {
              type: 'integer',
              description: 'Category ID',
            },
            user_id: {
              type: 'integer',
              description: 'User ID who created the product',
            },
            status_id: {
              type: 'integer',
              description: 'Product status ID',
            },
          },
        },
        Error: {
          type: 'object',
          properties: {
            status: {
              type: 'string',
              example: 'error',
            },
            message: {
              type: 'string',
              description: 'Error message',
            },
          },
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: ['./controllers/*.ts', './routes/*.ts'],
}

const swaggerSpec = swaggerJsdoc(options)

export default swaggerSpec
