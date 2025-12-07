SELECT
  COUNT(*) AS n_rows,
  COUNT(DISTINCT IDpol) AS n_policies,
  SUM(Exposure) AS total_exposure,
  SUM(ClaimNb) AS total_claims,
  SAFE_DIVIDE(SUM(ClaimNb), SUM(Exposure)) AS overall_claim_frequency
FROM
  `alert-autumn-340322.motor_claims.freMTPL2freq`
WHERE
  Exposure > 0;
