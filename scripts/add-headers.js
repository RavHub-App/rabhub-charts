const fs = require('fs');
const path = require('path');

const HEADERS = {
    core: `/*
 * Copyright (C) 2026 RavHub Team
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 */
`,
    proprietary: `/*
 * Copyright (C) 2026 RavHub Team. All Rights Reserved.
 *
 * This software is proprietary and confidential.
 *
 * NOTICE: All information contained herein is, and remains the property of
 * RavHub Team. Dissemination of this information or reproduction of this
 * material is strictly forbidden unless prior written permission is obtained
 * from RavHub Team.
 */
`,
    apache: `/*
 * Copyright (C) 2026 RavHub Team
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
`
};

const MAPPINGS = {
    'ravhub-core': HEADERS.core,
    'ravhub-enterprise': HEADERS.proprietary,
    'ravhub-license-portal': HEADERS.proprietary,
    'ravhub-charts': HEADERS.apache
};

const SKIP_DIRS = ['node_modules', 'dist', '.git', '.next', 'coverage'];
const EXTENSIONS = ['.ts', '.tsx', '.js', '.jsx'];

function addHeader(filePath, header) {
    try {
        const content = fs.readFileSync(filePath, 'utf8');
        if (content.trim().startsWith('/*')) {
            // Already has a header (simple check), skipping to avoid duplication
            // ideally check if it matches OUR header, but for safety lets skip
            return;
        }
        fs.writeFileSync(filePath, header + '\n' + content);
        console.log(`Updated: ${filePath}`);
    } catch (e) {
        console.error(`Error updating ${filePath}:`, e);
    }
}

function processDir(dir, header) {
    const files = fs.readdirSync(dir);

    for (const file of files) {
        if (SKIP_DIRS.includes(file)) continue;

        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            processDir(fullPath, header);
        } else if (EXTENSIONS.includes(path.extname(file))) {
            addHeader(fullPath, header);
        }
    }
}

function main() {
    const rootDir = path.dirname(__dirname); // Assumes scripts/add-headers.js

    for (const [folder, header] of Object.entries(MAPPINGS)) {
        const targetDir = path.join(rootDir, folder);
        if (fs.existsSync(targetDir)) {
            console.log(`Processing ${folder}...`);
            processDir(targetDir, header);
        } else {
            console.warn(`Warning: ${folder} not found in ${rootDir}`);
        }
    }
}

main();
