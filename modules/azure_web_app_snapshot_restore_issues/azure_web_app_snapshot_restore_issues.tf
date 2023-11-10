resource "shoreline_notebook" "azure_web_app_snapshot_restore_issues" {
  name       = "azure_web_app_snapshot_restore_issues"
  data       = file("${path.module}/data/azure_web_app_snapshot_restore_issues.json")
  depends_on = [shoreline_action.invoke_restore_webapp_snapshot]
}

resource "shoreline_file" "restore_webapp_snapshot" {
  name             = "restore_webapp_snapshot"
  input_file       = "${path.module}/data/restore_webapp_snapshot.sh"
  md5              = filemd5("${path.module}/data/restore_webapp_snapshot.sh")
  description      = "Restore the app from the recent verified snapshot"
  destination_path = "/tmp/restore_webapp_snapshot.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_restore_webapp_snapshot" {
  name        = "invoke_restore_webapp_snapshot"
  description = "Restore the app from the recent verified snapshot"
  command     = "`chmod +x /tmp/restore_webapp_snapshot.sh && /tmp/restore_webapp_snapshot.sh`"
  params      = ["WEB_APP_NAME","RESOURCE_GROUP_NAME"]
  file_deps   = ["restore_webapp_snapshot"]
  enabled     = true
  depends_on  = [shoreline_file.restore_webapp_snapshot]
}

