<?php get_header(); ?>
	<?php the_post(); ?>
		<div id="page-<?php the_ID(); ?>">
			<?php if ( has_post_thumbnail() ) { ?>
				<div>
					<?php the_post_thumbnail(); ?>
				</div>
			<?php } ?>
			<h1><?php the_title(); ?></h1>
			<?php the_content(); ?>
		</div>
	<?php comments_template( '', true ); ?>
<?php get_sidebar(); ?>
<?php get_footer(); ?>