<div id="sidebar">
	<ul>
		<?php
			if ( ! dynamic_sidebar( 'sidebar' ) ) {
				the_widget( 'WP_Widget_Recent_Posts', array( 'number' => 5 ), array( 'widget_id' => NULL ) );
			}
		?>
	</ul>
</div><!--end sidebar-->