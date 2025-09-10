const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);

// Create Socket.IO server
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Handle socket connections
io.on("connection", (socket) => {
  console.log("New client connected:", socket.id);

  // Listen for chat messages
  socket.on("chatMessage", (msg) => {
    console.log("Message received:", msg);

    // Broadcast to all clients
    io.emit("chatMessage", {
      id: socket.id,
      text: msg,
      timestamp: new Date()
    });
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });
});

// Express route
app.get("/", (req, res) => {
  res.send("Socket.IO + Express server running 🚀");
});

// Start server
const PORT = 3000;
server.listen(PORT, () => {
  console.log(`Server running at http://3.111.86.244:${PORT}`);
});
