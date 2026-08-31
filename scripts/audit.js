const fs = require('fs');
const path = require('path');

const contractsDir = path.join(__dirname, '..', 'contracts');

const checks = [
  {
    name: 'Reentrancy protection',
    pattern: /nonReentrant|ReentrancyGuard/,
    severity: 'high',
  },
  {
    name: 'Ownable pattern',
    pattern: /Ownable|onlyOwner/,
    severity: 'medium',
  },
  {
    name: 'Overflow protection',
    pattern: /pragma solidity \^0\.8/,
    severity: 'high',
  },
  {
    name: 'Access control',
    pattern: /modifier|require.*msg\.sender/,
    severity: 'medium',
  },
];

function auditFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const results = [];
  
  checks.forEach(check => {
    if (check.pattern.test(content)) {
      results.push({ name: check.name, status: 'PASS', severity: check.severity });
    } else {
      results.push({ name: check.name, status: 'WARN', severity: check.severity });
    }
  });
  
  return results;
}

function walkDir(dir) {
  const files = [];
  const items = fs.readdirSync(dir);
  
  items.forEach(item => {
    const fullPath = path.join(dir, item);
    const stat = fs.statSync(fullPath);
    if (stat.isDirectory()) {
      files.push(...walkDir(fullPath));
    } else if (item.endsWith('.sol')) {
      files.push(fullPath);
    }
  });
  
  return files;
}

const contracts = walkDir(contractsDir);
console.log(`Auditing ${contracts.length} contracts...\n`);

contracts.forEach(file => {
  console.log(`File: ${path.basename(file)}`);
  const results = auditFile(file);
  results.forEach(r => {
    const icon = r.status === 'PASS' ? '✓' : '⚠';
    console.log(`  ${icon} ${r.name} [${r.severity}]`);
  });
  console.log('');
});

const warnings = contracts.flatMap(f => auditFile(f).filter(r => r.status === 'WARN'));
console.log(`Total warnings: ${warnings.length}`);
if (warnings.length > 0) {
  console.log('Review these before deployment.');
}
