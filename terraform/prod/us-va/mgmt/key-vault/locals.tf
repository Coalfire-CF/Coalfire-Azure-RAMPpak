locals {
  #   app_subnet_ids = [concat(
  #     values(data.terraform_remote_state.usgv_app_ath.outputs.usgv_app_ath_vnet_subnet_ids),  
  #     values(data.terraform_remote_state.usgv_app_awb.outputs.usgv_app_awb_vnet_subnet_ids),
  #     values(data.terraform_remote_state.usgv_app_edl.outputs.usgv_app_eiq_vnet_subnet_ids),
  #     values(data.terraform_remote_state.usgv_app_edl.outputs.usgv_app_rca_vnet_subnet_ids),
  #     values(data.terraform_remote_state.usgv_app_psd.outputs.usgv_app_psd_vnet_subnet_ids),
  #     values(data.terraform_remote_state.usgv_app_sae.outputs.usgv_app_sae_vnet_subnet_ids),
  #     values(data.terraform_remote_state.usgv_app_sdl.outputs.usgv_app_sdl_vnet_subnet_ids),
  #     values(data.terraform_remote_state.usgv_app_spark.outputs.usgv_app_spark_vnet_subnet_ids),
  #     values(data.terraform_remote_state.usgv_app_v1platform.outputs.usgv_app_v1platform_vnet_subnet_ids),
  #     values(data.terraform_remote_state.usgv_app_v1platform.outputs.usgv_app_v1platform_ha_vnet_subnet_ids),
  #   )]
  app_subnet_ids = []
}