const hre = require('hardhat');
const path = require('path');
const fs = require('fs');

const CONTRACT_FILE = 'Pengulet.sol';
const SDPX_LICENSE = 'BSD-3-Clause';
const OUT_DIR = path.join(__dirname, '..', 'dist');

async function main() {
    let flat = '';
    const originalStdoutWrite = process.stdout.write.bind(process.stdout);

    process.stdout.write = (chunk) => {
        if (typeof chunk === 'string') {
            flat += chunk;
        }
    };

    await hre.run('flatten', {
        files: [path.join(__dirname, '..', 'contracts', CONTRACT_FILE)]
    });

    process.stdout.write = originalStdoutWrite;

    let out = flat
        .replace(/\/\/ SPDX-License-Identifier: (.*)/gi, (_, p1) => `// ${p1}`)
        .replace(/\/\/ File .*/gi, '')
        .split('\n');
    out.splice(0, 0, `// SPDX-License-Identifier: ${SDPX_LICENSE}`);
    out = out.join('\n');

    fs.mkdirSync(OUT_DIR, { recursive: true });
    fs.writeFileSync(path.join(OUT_DIR, `Flat${CONTRACT_FILE}`), out);
}

main()
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
