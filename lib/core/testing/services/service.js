const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'service.json');

function getServiceData() {
  try {
    const fileContent = fs.readFileSync(filePath, 'utf8').replace(/^\uFEFF/, '');
    return JSON.parse(fileContent);
  } catch (error) {
    return {
      error: 'Unable to read service.json',
      details: error.message,
    };
  }
}

module.exports = { getServiceData };
