const { spawn } = require('child_process');


const command = 'luvit';
const args = ['Bot.lua'];


const luaProcess = spawn(command, args);


luaProcess.stdout.on('data', (data) => {
    console.log(`Output: ${data}`);
});


luaProcess.stderr.on('data', (data) => {
    console.error(`Error: ${data}`);
});


luaProcess.on('close', (code) => {
    console.log(`Luvit process exited with code ${code}`);
});
