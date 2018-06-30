update wt_site_setting
    set setting_value=${site.protocol}:${site.hostname}${appconfig.context}/
    where setting_name = 'SERVER_URL';
