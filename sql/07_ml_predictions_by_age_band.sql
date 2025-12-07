-- Aggregated observed vs predicted frequency by age band (for Looker chart)
CREATE OR REPLACE TABLE `project-id.motor_claims.predictions_by_age_band` AS
WITH with_band AS (
  SELECT
    *,
    CONCAT(
      CAST(DIV(DrivAge, 5) * 5 AS STRING),
      '-',
      CAST(DIV(DrivAge, 5) * 5 + 4 AS STRING)
    ) AS age_band
  FROM
    `project-id.motor_claims.freq_with_split`
  WHERE
    split = 'TEST'
)
SELECT
  age_band,
  SUM(Exposure) AS total_exposure,
  SUM(ClaimNb) AS total_claims,
  SAFE_DIVIDE(SUM(ClaimNb), SUM(Exposure)) AS actual_freq,
  AVG(predicted_ClaimFrequency) AS avg_predicted_freq
FROM
  ML.PREDICT(
    MODEL `project-id.motor_claims.claimfreq_reg`,
    (SELECT * FROM with_band)
  )
GROUP BY
  age_band
ORDER BY
  CAST(SPLIT(age_band, '-')[OFFSET(0)] AS INT64);
