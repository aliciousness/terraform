import sys
import os
import pytest
from unittest.mock import patch, MagicMock
import botocore

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
from lambda_function import get_parameter


class TestParameterStore:

    @patch("boto3.client")
    def test_successful_parameter_retrieval(self, mock_boto3):
        mock_ssm = MagicMock()
        mock_boto3.return_value = mock_ssm
        mock_ssm.get_parameter.return_value = {"Parameter": {"Value": "test-value"}}

        result = get_parameter("test-param")
        assert result == "test-value"
        mock_ssm.get_parameter.assert_called_once_with(
            Name="test-param", WithDecryption=True
        )

    @patch("boto3.client")
    def test_parameter_not_found(self, mock_boto3):
        mock_ssm = MagicMock()
        mock_boto3.return_value = mock_ssm
        mock_ssm.get_parameter.side_effect = botocore.exceptions.ClientError(
            {"Error": {"Code": "ParameterNotFound", "Message": "Parameter not found"}},
            "GetParameter",
        )

        with pytest.raises(Exception):
            get_parameter("non-existent-param")
