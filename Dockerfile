# Stage 1: Build the frontend
FROM node:22-alpine AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Build the backend and serve the app
FROM node:22-alpine
WORKDIR /app/backend

# Copy backend dependencies and source code
COPY backend/package*.json ./
RUN npm install --production
COPY backend/ ./

# Copy the built frontend static files to the backend
COPY --from=frontend-builder /app/frontend/dist ./public

# Note: You may need to update your backend/server.js to serve the static files from the 'public' directory
# Example: app.use(express.static(path.join(__dirname, 'public')));

EXPOSE 5000
CMD ["node", "server.js"]
