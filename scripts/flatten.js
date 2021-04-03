const hre = require('hardhat');
const path = require('path');
const fs = require('fs');

async function main() {
    let flat = '';
    const originalStdoutWrite = process.stdout.write.bind(process.stdout);

    process.stdout.write = (chunk) => {
        if (typeof chunk === 'string') {
            flat += chunk;
        }
    };

    await hre.run('flatten', {
        files: [path.join(__dirname, '..', 'contracts', 'Pengulet.sol')]
    });

    process.stdout.write = originalStdoutWrite;

    let out = flat
        .replace(/\/\/ SPDX-License-Identifier: (.*)/gi, (_, p1) => `// ${p1}`)
        .split('\n');
    out.splice(0, 0, '// SPDX-License-Identifier: BSD-3-Clause');
    out = out.join('\n');

    fs.writeFileSync(path.join(__dirname, '..', 'contracts', 'FlatPengulet.sol'), out);
}

main()
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
