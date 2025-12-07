-- Add claim frequency and a random train/test split
CREATE OR REPLACE TABLE `project-id.motor_claims.freq_with_split` AS
SELECT
  *,
  SAFE_DIVIDE(ClaimNb, Exposure) AS ClaimFrequency,
  IF(RAND() < 0.8, 'TRAIN', 'TEST') AS split
FROM
  `project-id.motor_claims.freMTPL2freq`
WHERE
  Exposure > 0;
