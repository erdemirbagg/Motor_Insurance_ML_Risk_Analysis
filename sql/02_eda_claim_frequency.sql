-- Claim frequency by region
CREATE OR REPLACE TABLE `project-id.motor_claims.freq_by_region` AS
SELECT
  Region,
  COUNT(*) AS n_rows,
  SUM(Exposure) AS total_exposure,
  SUM(ClaimNb) AS total_claims,
  SAFE_DIVIDE(SUM(ClaimNb), SUM(Exposure)) AS claim_frequency
FROM
  `project-id.motor_claims.freMTPL2freq`
WHERE
  Exposure > 0
GROUP BY
  Region
ORDER BY
  claim_frequency DESC;

-- Claim frequency by area (A–F)
CREATE OR REPLACE TABLE `project-id.motor_claims.freq_by_area` AS
SELECT
  Area,
  COUNT(*) AS n_rows,
  SUM(Exposure) AS total_exposure,
  SUM(ClaimNb) AS total_claims,
  SAFE_DIVIDE(SUM(ClaimNb), SUM(Exposure)) AS claim_frequency
FROM
  `project-id.motor_claims.freMTPL2freq`
WHERE
  Exposure > 0
GROUP BY
  Area
ORDER BY
  claim_frequency DESC;

-- Claim frequency by 5-year age bands
CREATE OR REPLACE TABLE `project-id.motor_claims.freq_by_age_band` AS
WITH binned AS (
  SELECT
    ClaimNb,
    Exposure,
    DrivAge,
    CONCAT(
      CAST(DIV(DrivAge, 5) * 5 AS STRING),
      '-',
      CAST(DIV(DrivAge, 5) * 5 + 4 AS STRING)
    ) AS age_band
  FROM
    `project-id.motor_claims.freMTPL2freq`
  WHERE
    Exposure > 0
)
SELECT
  age_band,
  SUM(Exposure) AS total_exposure,
  SUM(ClaimNb) AS total_claims,
  SAFE_DIVIDE(SUM(ClaimNb), SUM(Exposure)) AS claim_frequency
FROM
  binned
GROUP BY
  age_band
ORDER BY
  CAST(SPLIT(age_band, '-')[OFFSET(0)] AS INT64);
