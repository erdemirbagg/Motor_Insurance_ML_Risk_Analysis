-- Evaluate the model
SELECT
  *
FROM
  ML.EVALUATE(MODEL `project-id.motor_claims.claimfreq_reg`);
