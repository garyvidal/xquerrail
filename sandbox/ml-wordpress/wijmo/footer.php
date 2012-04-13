<?php
/**
 * The template for displaying the footer.
 *
 * Contains the closing of the id=main div and all content
 * after.  Calls sidebar-footer.php for bottom widgets.
 *
 * @package WordPress
 * @subpackage Twenty_Ten
 * @since Twenty Ten 1.0
 */
?>
</div>
<!-- #main -->

<div id="footer" role="contentinfo" class="ui-widget-content">
  <div id="colophon">
    <?php
	/* A sidebar in the footer? Yep. You can can customize
	 * your footer with four columns of widgets.
	 */
	get_sidebar( 'footer' );
?>
    <!-- Navigation -->
    <div id="footer-access" role="navigation">
      <?php /*  Allow screen readers / text browsers to skip the navigation menu and get right to the good stuff */ ?>
      <div class="skip-link screen-reader-text"><a href="#content" title="<?php esc_attr_e( 'Skip to content', 'twentyten' ); ?>">
        <?php _e( 'Skip to content', 'twentyten' ); ?>
        </a></div>
      <?php /* Our navigation menu.  If one isn't filled out, wp_nav_menu falls back to wp_page_menu.  The menu assiged to the primary position is the one used.  If none is assigned, the menu with the lowest ID is used.  */ ?>
      <ul id="wijmofootermenu">
        <?php wp_list_pages( 'title_li=' ); ?>
      </ul>
    </div>
    <div id="footer-meta">
      <ul>
        <?php wp_register('<li class="ui-state-default"><span class="ui-icon ui-icon-person"></span>','</li>'); ?>
        <li class="ui-state-default"> <span class="ui-icon ui-icon-transferthick-e-w"></span>
          <?php wp_loginout(); ?>
        </li>
        <?php wp_meta(); ?>
        <li class="ui-state-default"><span class="ui-icon ui-icon-signal-diag"></span> <a href="<?php bloginfo('rss_url'); ?>">RSS</a> </li>
        <li class="ui-state-default"> <span class="ui-icon ui-icon-signal"></span><a href="<?php bloginfo('pingback_url'); ?>">Pingback</a> </li>
        <li class="ui-state-default"> <span class="ui-icon ui-icon-signal-diag"></span><a href="<?php bloginfo('comments_rss2_url'); ?>">Comments RSS</a> </li>
      </ul>
    </div>
    <div id="footer-social">
      <ul>
        <li class="ui-state-default"><span class="ui-icon ui-icon-twitter"></span> <a href="http://twitter.com/wijmo">Twitter</a> </li>
        <li class="ui-state-default"> <span class="ui-icon ui-icon-facebook"></span><a href="http://facebook.com/wijmo>">Facebook</a> </li>
      </ul>
    </div>
    <div id="footer-copyright"> <img src="<?php bloginfo('template_url') ?>/images/wijmo_c1logo.png" />
      <p>&copy;1987-<?php echo date("Y"); ?> ComponentOne LLC All Rights Reserved. All product and company names herein may be trademarks of their respective owners. </p>
    </div>
  </div>
  <!-- #colophon -->
</div>
<!-- #footer -->
</div>
<!-- #wrapper -->
<div id="site-generator" class="ui-widget-header">
  <?php do_action( 'twentyten_credits' ); ?>
  <a href="<?php echo esc_url( __('http://wordpress.org/', 'twentyten') ); ?>"
						title="<?php esc_attr_e('Semantic Personal Publishing Platform', 'twentyten'); ?>" rel="generator"> <?php printf( __('Proudly powered by %s.', 'twentyten'), 'WordPress' ); ?> </a> </div>
<!-- #site-generator -->
<?php
	/* Always have wp_footer() just before the closing </body>
	 * tag of your theme, or you will break many plugins, which
	 * generally use this hook to reference JavaScript files.
	 */

	wp_footer();
?>
</body></html>