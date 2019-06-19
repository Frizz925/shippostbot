resource "aws_lambda_function" "shippostbot_lambda" {
  function_name = "ShippostBot"
  role = "${aws_iam_role.shippostbot_lambda_role.arn}"
  handler = "lambda_function.lambda_handler"

  runtime = "python3.7"
  memory_size = 256
  timeout = 300

  environment {
    variables = {
      FACEBOOK_ACCESS_TOKEN = "${var.facebook_access_token}"
      FACEBOOK_PAGE_ID = "${var.facebook_page_id}"
      S3_BUCKET_NAME = "${var.s3_bucket_name}"
      S3_REGION = "${var.aws_region}"
    }
  }

  tags = {
    App = "ShippostBot"
    Environment = "Production"
    Service = "Lambda"
  }
}

resource "aws_iam_role" "shippostbot_lambda_role" {
  name = "ShippostBot-lambda-role"
  path = "/shippostbot/"
  assume_role_policy = "${data.aws_iam_policy_document.shippostbot_lambda_role.json}"
}

resource "aws_cloudwatch_event_target" "shippostbot_lambda_event" {
  rule = "${aws_cloudwatch_event_rule.shippostbot_scheduler.name}"
  arn = "${aws_lambda_function.shippostbot_lambda.arn}"
}

resource "aws_iam_role_policy_attachment" "shippostbot_lambda_log" {
  role = "${aws_iam_role.shippostbot_lambda_role.name}"
  policy_arn = "${aws_iam_policy.shippostbot_log_access_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "shippostbot_lambda_s3" {
  role = "${aws_iam_role.shippostbot_lambda_role.name}"
  policy_arn = "${aws_iam_policy.shippostbot_s3_access_policy.arn}"
}

data "aws_iam_policy_document" "shippostbot_lambda_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}