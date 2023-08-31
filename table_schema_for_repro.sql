CREATE TABLE public.bug_repro_values (
    id bigint NOT NULL,
    condition_category text NOT NULL,
    condition_value integer NOT NULL
    CONSTRAINT contrived_condition_check CHECK (
CASE
    WHEN (condition_category = 'must_be_positive') THEN (condition_value > 0)
    WHEN (condition_category = 'must_be_negative') THEN (condition_value < 0)
    ELSE true
END)
);
