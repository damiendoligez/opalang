/*
    Copyright © 2011, 2012 MLstate

    This file is part of OPA.

    OPA is free software: you can redistribute it and/or modify it under the
    terms of the GNU Affero General Public License, version 3, as published by
    the Free Software Foundation.

    OPA is distributed in the hope that it will be useful, but WITHOUT ANY
    WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for
    more details.

    You should have received a copy of the GNU Affero General Public License
    along with OPA. If not, see <http://www.gnu.org/licenses/>.
*/

/**
 * {1 About this module}
 *
 * This module allows you to use Twitter's Bootstrap style (http://twitter.github.com/bootstrap/) directly in your application.
 * It also includes several sets of icons.
 *
 * {1 Where should I start}
 *
 * If you want to use the latest version, just import this package (stdlib.themes.bootstrap).
 * Otherwise, import stdlib.themes.bootstrap.v{X.Y.Z}.
 * /!\ If the version you are looking for is not embed in Opa, it will reference GitHub's URL.
 *
 * {1 How to use Opa icons}
 *
 * import stdlib.bootstrap.css and stdlib.bootstrap.opa-icons only (not the whole package)
 *
 * There are different sizes:
 * - to use 16x16 pixels icon, set class "icon"
 * - to use 32x32 pixels icon, set class "icon32"
 * There are different colors:
 * - gray is the default
 * - to use black color, set class "icon-white"
 * - to use white color, set class "icon-black"
 * There are different icons:
 * - triangle (icon-triangle-n,icon-triangle-e, ...)
 * - arrow (icon-arrow-n, icon-arrowthick-n, icon-arrowreturn-se, ...)
 * - icon-plus, icon-minus, icon-close, icon-check, icon-help, icon-notice ...
 *
 * See: http://bootstrap.opalang.org for more info
 *
 * {1 How to use Font Awesome icons}
 *
 * import stdlib.bootstrap.css and stdlib.bootstrap.font-awesome (not the whole package)
 *
 * Font Awesome - http://fortawesome.github.com/Font-Awesome
 *
 * {1 Examples}
 *
 * import stdlib.themes.bootstrap               // import bootstrap css and icons without responsive
 * import stdlib.themes.bootstrap.responsive    // import bootstrap responsive part
 * import stdlib.themes.bootstrap.css           // import bootstrap css (no icons, no responsive)
 * import stdlib.themes.bootstrap.icons         // import bootstrap glyphicons
 * import stdlib.themes.bootstrap.opa-icons     // import opa icons for bootstrap
 * import stdlib.themes.font-awesome            // import font awesome icons
 */
Bootstrap = {{

  @private
  config = { DynamicResource.default_config with randomize = false }

  @private
  params = {
    expiration={none}
    consumption={unlimited}
    visibility={shared}
  }

  @private
  publish(name, resource) =
    DynamicResource.publish_extend(name, resource, params, config)

  /** Opa resources **/

  @private
  opa_resources_path = "lib/stdlib/themes/bootstrap/opa-resources"

  @private
  opa_resources = @static_include_directory("lib/stdlib/themes/bootstrap/opa-resources")

  @private
  uri_opa = Map.mapi(publish, opa_resources)

  @package
  import_opa_icons() =
    match Map.get("{opa_resources_path}/css/icons.css", uri_opa)
    {none} -> void
    {some=uri} -> Resource.register_external_css(uri)

  /** Font Awesome resources **/

  @private
  font_awesome_resources_path = "lib/stdlib/themes/bootstrap/font-awesome"

  @private
  font_awesome_resources = @static_include_directory("lib/stdlib/themes/bootstrap/font-awesome")

  @private
  uri_font_awesome = Map.mapi(publish, font_awesome_resources)

  @package
  import_font_awesome() =
    match Map.get("{font_awesome_resources_path}/css/font-awesome.css", uri_font_awesome)
    {none} -> void
    {some=uri} -> Resource.register_external_css(uri)

  /** Bootstrap resources **/

  @private
  bs_resources_path = "lib/stdlib/themes/bootstrap/bs-resources"

  @private
  bs_resources = @static_include_directory("lib/stdlib/themes/bootstrap/bs-resources")

  @private
  uri_bs = Map.mapi(publish, bs_resources)

  @private
  import_bs(name:string) =
    match Map.get(name, uri_bs)
    {some=url} -> Resource.register_external_css(url)
    {none} -> void

  @private
  fallback_url(v:string) =
    if String.le(v, "1.4.0") then
      "http://twitter.github.com/bootstrap/{v}/bootstrap.min.css"
    else
      "http://twitter.github.com/bootstrap/assets/css/bootstrap.css"

  @package
  import_css(v:string) =
    import_bs("{bs_resources_path}/{v}/css/bootstrap-css.min.css")

  @package
  import_responsive_css(v:string) =
    import_bs("{bs_resources_path}/{v}/css/bootstrap-responsive.min.css")

  @package
  import_icons(v:string) =
    if String.lt(v, "2.0.0") then import_opa_icons()
    else
      do import_bs("{bs_resources_path}/{v}/css/bootstrap-glyphicons.min.css")
      do import_bs("{bs_resources_path}/{v}/css/glyphicons-halflings-white.min.css")
      void

  /**
   * Import a specific version of Bootstrap, with its icons
   */
  import(v:string) =
    Map.get("{bs_resources_path}/{v}/css/bootstrap.min.css", uri_bs) ?
    fallback_url(v) // fallback to github
    |> Resource.register_external_css(_)

  /**
   * Latest version of Bootstrap included in Opa
   */
  latest = "2.0.4"

}}