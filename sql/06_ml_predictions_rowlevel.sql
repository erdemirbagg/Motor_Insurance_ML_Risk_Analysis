-- Row-level predictions on the TEST split
CREATE OR REPLACE TABLE `project-id.motor_claims.predictions_rowlevel` AS
WITH preds AS (
  SELECT
    *
  FROM
    ML.PREDICT(
      MODEL `project-id.motor_claims.claimfreq_reg`,
      (
        SELECT
          *
        FROM
          `project-id.motor_claims.freq_with_split`
        WHERE
          split = 'TEST'
      )
    )
)
SELECT
  IDpol,
  Exposure,
  ClaimNb,
  ClaimFrequency AS actual_freq,
  predicted_ClaimFrequency AS predicted_freq
FROM
  preds;
