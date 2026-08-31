# Contract Audit Kit

A collection of smart contract templates with built-in security patterns and audit helpers.

## What's inside

- **Templates**: Ready-to-use contract patterns (ERC20, ERC721, staking, multisig)
- **Checklist**: Security audit checklist for common vulnerabilities
- **Scripts**: Automated checks for known issues

## Structure

```
contracts/
  templates/     Reusable contract patterns
  audit/         Audit helper contracts
scripts/
  audit.js       Automated security checks
docs/
  checklist.md   Security audit checklist
```

## Usage

```bash
npm install
npx hardhat compile
node scripts/audit.js
```

## License

MIT
