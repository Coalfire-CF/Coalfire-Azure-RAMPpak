# Backup Deployment

Depends on

- Region Setup

## tstate.tf changes

Ensure these values are correct

- resource group
- storage account
- storage container
- unique key

## backupConfig.tf

Update vault name depending on customer convention. No other changes should be needed.

## backupVM.tf

Add VM ID's for backup.

Update backup frequency and retention policy if needed.

## remote-data.tf

add/uncomment out resource block for backup after ```terraform apply```

re-run ```terraform apply```

## Next steps

TODO
