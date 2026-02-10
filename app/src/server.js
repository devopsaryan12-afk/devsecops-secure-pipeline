const express = require("express");
const os = require("os");

const app = express();
const PORT = 8000;

app.get("/", (req, res) => {
  res.json({
    message: "DevSecOps Pipeline Running",
    hostname: os.hostname(),
    timestamp: new Date().toISOString()
  });
});

app.get("/health", (req, res) => {
  res.send('Hello, I am healthy!');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
