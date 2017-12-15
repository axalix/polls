S3 = YAML.load_file("#{Rails.root}/config/settings/s3.yml")[Rails.env] # TODO: would be cool to have a service for loading yaml config files

AWS.config(
    access_key_id:      S3['access_key_id'],
    secret_access_key:  S3['secret_access_key']
)