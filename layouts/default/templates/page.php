<?php get_header(); ?>
<div id="content" class="clear">
	<?php the_post(); ?>
		<div id="page-<?php the_ID(); ?>" class="page clear">
			<?php if ( has_post_thumbnail() ) { ?>
				<div class="entry-page-image">
					<?php the_post_thumbnail(); ?>
				</div>
			<?php } ?>
			<h1 class="page-title"><?php the_title(); ?></h1>
			<div class="entry entry-page clear">
				<?php the_content(); ?>
			</div>
		</div>
	<?php comments_template( '', true ); ?>
</div><!--end content-->
<?php get_sidebar(); ?>
<?php get_footer(); ?>