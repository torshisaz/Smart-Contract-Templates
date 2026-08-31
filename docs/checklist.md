# Security Audit Checklist

## High Priority

- [ ] Reentrancy guards on all state-changing functions
- [ ] Access control on owner-only functions
- [ ] Input validation on all public functions
- [ ] No unchecked external calls
- [ ] Proper initialization (no uninitialized proxies)

## Medium Priority

- [ ] Events emitted on critical actions
- [ ] Pausing mechanism for emergencies
- [ ] Rate limiting on sensitive operations
- [ ] Slippage protection on swaps

## Low Priority

- [ ] Gas optimization
- [ ] Consistent naming conventions
- [ ] Documentation completeness

## Testing

- [ ] Unit tests for all functions
- [ ] Fork tests against mainnet
- [ ] Fuzz testing on critical paths
- [ ] Invariant tests for core logic
