-- Train a simple claim frequency model with BigQuery ML
CREATE OR REPLACE MODEL `project-id.motor_claims.claimfreq_reg`
OPTIONS(
  model_type = 'linear_reg',
  input_label_cols = ['ClaimFrequency']
) AS
SELECT
  ClaimFrequency,
  split,
  IDpol,
  DrivAge,
  VehAge,
  BonusMalus,
  VehPower,
  Density,
  CAST(Area AS STRING) AS Area,
  CAST(Region AS STRING) AS Region,
  VehBrand,
  VehGas
FROM
  `project-id.motor_claims.freq_with_split`;
