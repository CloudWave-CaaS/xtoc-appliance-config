const express = require('express');
const app = express();
const port = 8080;

app.use(express.static('public'));
app.get('/',(req,res) => {
	res.send('HELLO WORLD- node.js');
});

app.listen(port,()=> {
	console.log(`WEB SVC RUNNING:  localhost:${port}`);
});
