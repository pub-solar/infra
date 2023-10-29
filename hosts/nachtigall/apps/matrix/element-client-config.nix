{
	default_server_config = {
		"m.homeserver" = {
			base_url = "https://matrix.test.pub.solar";
			server_name = "test.pub.solar";
		};
		"m.identity_server" = {
			base_url = "";
		};
	};
  # TODO: Add themes
	# setting_defaults = {
	# 	custom_themes = {{ matrix_client_element_setting_defaults_custom_themes | to_json }}
	# };
	# default_theme = {{ matrix_client_element_default_theme | string | to_json }};
	# default_country_code = {{ matrix_client_element_default_country_code | string | to_json }};
	permalink_prefix = "https://matrix.to";
	disable_custom_urls = true;
	disable_guests = true;
	brand = "Element Solar";

  # TODO: Configure these
	integrations_ui_url = "";
	integrations_rest_url = "";
	integrations_widgets_urls = "";
	integrations_jitsi_widget_url = "";

	bug_report_endpoint_url = "https://element.io/bugreports/submit";
	show_labs_settings = true;
	room_directory = {
		servers = ["matrix.org"];
	};
  # TODO: This looks wrong
	enable_presence_by_hs_url = "\n";
	embedded_pages = {
		homeUrl = "";
	};
	branding = {
		auth_footer_links = [{
      text = "Privacy";
      url = "https://pub.solar/privacy";
    }];
    # FUTUREWORK: Replace with pub.solar logo
		auth_header_logo_url = "themes/element/img/logos/element-logo.svg";
	};
}
