drop trigger if exists "ab_tests_updated_at" on "public"."ab_tests";

drop trigger if exists "update_app_configs_updated_at" on "public"."app_configs";

drop trigger if exists "trigger_update_banner_stats" on "public"."banner_interactions";

drop trigger if exists "update_brands_updated_at" on "public"."brands";

drop trigger if exists "trigger_increment_coupon_usage" on "public"."coupons";

drop trigger if exists "update_customers_updated_at" on "public"."customers";

drop trigger if exists "trigger_auto_disable_out_of_stock" on "public"."inventory";

drop trigger if exists "update_menu_categories_updated_at" on "public"."menu_categories";

drop trigger if exists "trigger_auto_disable_on_zero_inventory" on "public"."menu_items";

drop trigger if exists "trigger_cascade_master_menu" on "public"."menu_items";

drop trigger if exists "update_menu_items_updated_at" on "public"."menu_items";

drop trigger if exists "update_menu_modifiers_updated_at" on "public"."menu_modifiers";

drop trigger if exists "trigger_award_loyalty_points" on "public"."orders";

drop trigger if exists "trigger_award_stamps" on "public"."orders";

drop trigger if exists "trigger_decrease_inventory_on_order" on "public"."orders";

drop trigger if exists "trigger_log_order_status_change" on "public"."orders";

drop trigger if exists "trigger_sync_order_total_amount" on "public"."orders";

drop trigger if exists "update_orders_updated_at" on "public"."orders";

drop trigger if exists "trigger_validate_pickup_reservation" on "public"."pickup_reservations";

drop trigger if exists "update_pickup_slots_updated_at" on "public"."pickup_slots";

drop trigger if exists "update_staff_updated_at" on "public"."staff";

drop trigger if exists "update_stores_updated_at" on "public"."stores";

drop trigger if exists "update_subscriptions_updated_at" on "public"."subscriptions";

drop policy "Brand admins can view conversions" on "public"."ab_test_conversions";

drop policy "Anyone can view exposures for brand tests" on "public"."ab_test_exposures";

drop policy "Brand admins can manage variants" on "public"."ab_test_variants";

drop policy "Brand admins can create ab_tests" on "public"."ab_tests";

drop policy "Brand admins can delete own ab_tests" on "public"."ab_tests";

drop policy "Brand admins can update own ab_tests" on "public"."ab_tests";

drop policy "Brand admins can view own ab_tests" on "public"."ab_tests";

drop policy "Brand admins can view their app builds" on "public"."app_builds";

drop policy "Brand admins can manage their app config" on "public"."app_configs";

drop policy "Brand admins can view banner interactions" on "public"."banner_interactions";

drop policy "Brand admins can view their brand" on "public"."brands";

drop policy "Only super admins can create brands" on "public"."brands";

drop policy "Super admins can update all brands" on "public"."brands";

drop policy "Super admins can view all brands" on "public"."brands";

drop policy "Brand admins can manage coupon templates" on "public"."coupon_templates";

drop policy "Brand admins can create coupons" on "public"."coupons";

drop policy "Brand admins can delete coupons" on "public"."coupons";

drop policy "Brand admins can manage coupons" on "public"."coupons";

drop policy "Brand admins can update coupons" on "public"."coupons";

drop policy "Brand admins can view coupons" on "public"."coupons";

drop policy "Customers can mark coupons as used" on "public"."coupons";

drop policy "Customers can view own coupons" on "public"."coupons";

drop policy "Customers can view their own coupons" on "public"."coupons";

drop policy "Brand admins can manage customer segments" on "public"."customer_segments";

drop policy "Brand admins can view their brand's customers" on "public"."customers";

drop policy "Customers can update their own profile" on "public"."customers";

drop policy "Customers can view their own profile" on "public"."customers";

drop policy "Super admins can view all customers" on "public"."customers";

drop policy "Staff can update their store's inventory" on "public"."inventory";

drop policy "Staff can view their store's inventory" on "public"."inventory";

drop policy "Customers can view their own loyalty transactions" on "public"."loyalty_transactions";

drop policy "Brand admins can delete menu categories" on "public"."menu_categories";

drop policy "Brand admins can insert menu categories" on "public"."menu_categories";

drop policy "Brand admins can update menu categories" on "public"."menu_categories";

drop policy "Brand admins can view their menu categories" on "public"."menu_categories";

drop policy "Customers can view available menu categories" on "public"."menu_categories";

drop policy "Brand admins can delete menu items" on "public"."menu_items";

drop policy "Brand admins can insert menu items" on "public"."menu_items";

drop policy "Brand admins can update menu items" on "public"."menu_items";

drop policy "Brand admins can view their menu items" on "public"."menu_items";

drop policy "Customers can view available menu items" on "public"."menu_items";

drop policy "Brand admins can delete menu modifiers" on "public"."menu_modifiers";

drop policy "Brand admins can insert menu modifiers" on "public"."menu_modifiers";

drop policy "Brand admins can update menu modifiers" on "public"."menu_modifiers";

drop policy "Brand admins can view their menu modifiers" on "public"."menu_modifiers";

drop policy "Customers can view menu modifiers" on "public"."menu_modifiers";

drop policy "Brand admins can manage menu schedules" on "public"."menu_schedules";

drop policy "Store managers can view menu schedules" on "public"."menu_schedules";

drop policy "Customers can view their own notifications" on "public"."notification_logs";

drop policy "Brand admins can manage notification templates" on "public"."notification_templates";

drop policy "Brand admins can manage notifications" on "public"."notifications";

drop policy "Customers can view own notifications" on "public"."notifications";

drop policy "Customers can view their order history" on "public"."order_status_history";

drop policy "Staff can manage order history for their store" on "public"."order_status_history";

drop policy "Customers can create orders" on "public"."orders";

drop policy "Customers can view their own orders" on "public"."orders";

drop policy "Staff can update their store's orders" on "public"."orders";

drop policy "Staff can view their store's orders" on "public"."orders";

drop policy "Customers can create reservations" on "public"."pickup_reservations";

drop policy "Customers can view their own reservations" on "public"."pickup_reservations";

drop policy "Staff can manage their store's pickup slots" on "public"."pickup_slots";

drop policy "Brand admins can create promotion banners" on "public"."promotion_banners";

drop policy "Brand admins can delete their promotion banners" on "public"."promotion_banners";

drop policy "Brand admins can update their promotion banners" on "public"."promotion_banners";

drop policy "Brand admins can view their promotion banners" on "public"."promotion_banners";

drop policy "Brand admins can manage promotions" on "public"."promotions";

drop policy "Brand admins can view customer push tokens" on "public"."push_tokens";

drop policy "Customers can delete own push tokens" on "public"."push_tokens";

drop policy "Customers can insert own push tokens" on "public"."push_tokens";

drop policy "Customers can update own push tokens" on "public"."push_tokens";

drop policy "Customers can view own push tokens" on "public"."push_tokens";

drop policy "Brand admins can manage recommended menu configs" on "public"."recommended_menu_configs";

drop policy "Customers can view their refunds" on "public"."refunds";

drop policy "Staff can manage refunds for their store" on "public"."refunds";

drop policy "Brand admins can manage staff" on "public"."staff";

drop policy "Staff can view their store's staff" on "public"."staff";

drop policy "Anon can view active stores" on "public"."stores";

drop policy "Brand admins can create stores" on "public"."stores";

drop policy "Brand admins can update their stores" on "public"."stores";

drop policy "Brand admins can view their stores" on "public"."stores";

drop policy "Customers can view active stores" on "public"."stores";

drop policy "Staff can view their store" on "public"."stores";

drop policy "Super admins can view all stores" on "public"."stores";

drop policy "Brand admins can view their subscription" on "public"."subscriptions";

drop policy "Only super admins can modify subscriptions" on "public"."subscriptions";

drop policy "Super admins can view all subscriptions" on "public"."subscriptions";

revoke delete on table "public"."ab_test_conversions" from "anon";

revoke insert on table "public"."ab_test_conversions" from "anon";

revoke references on table "public"."ab_test_conversions" from "anon";

revoke select on table "public"."ab_test_conversions" from "anon";

revoke trigger on table "public"."ab_test_conversions" from "anon";

revoke truncate on table "public"."ab_test_conversions" from "anon";

revoke update on table "public"."ab_test_conversions" from "anon";

revoke delete on table "public"."ab_test_conversions" from "authenticated";

revoke insert on table "public"."ab_test_conversions" from "authenticated";

revoke references on table "public"."ab_test_conversions" from "authenticated";

revoke select on table "public"."ab_test_conversions" from "authenticated";

revoke trigger on table "public"."ab_test_conversions" from "authenticated";

revoke truncate on table "public"."ab_test_conversions" from "authenticated";

revoke update on table "public"."ab_test_conversions" from "authenticated";

revoke delete on table "public"."ab_test_conversions" from "service_role";

revoke insert on table "public"."ab_test_conversions" from "service_role";

revoke references on table "public"."ab_test_conversions" from "service_role";

revoke select on table "public"."ab_test_conversions" from "service_role";

revoke trigger on table "public"."ab_test_conversions" from "service_role";

revoke truncate on table "public"."ab_test_conversions" from "service_role";

revoke update on table "public"."ab_test_conversions" from "service_role";

revoke delete on table "public"."ab_test_exposures" from "anon";

revoke insert on table "public"."ab_test_exposures" from "anon";

revoke references on table "public"."ab_test_exposures" from "anon";

revoke select on table "public"."ab_test_exposures" from "anon";

revoke trigger on table "public"."ab_test_exposures" from "anon";

revoke truncate on table "public"."ab_test_exposures" from "anon";

revoke update on table "public"."ab_test_exposures" from "anon";

revoke delete on table "public"."ab_test_exposures" from "authenticated";

revoke insert on table "public"."ab_test_exposures" from "authenticated";

revoke references on table "public"."ab_test_exposures" from "authenticated";

revoke select on table "public"."ab_test_exposures" from "authenticated";

revoke trigger on table "public"."ab_test_exposures" from "authenticated";

revoke truncate on table "public"."ab_test_exposures" from "authenticated";

revoke update on table "public"."ab_test_exposures" from "authenticated";

revoke delete on table "public"."ab_test_exposures" from "service_role";

revoke insert on table "public"."ab_test_exposures" from "service_role";

revoke references on table "public"."ab_test_exposures" from "service_role";

revoke select on table "public"."ab_test_exposures" from "service_role";

revoke trigger on table "public"."ab_test_exposures" from "service_role";

revoke truncate on table "public"."ab_test_exposures" from "service_role";

revoke update on table "public"."ab_test_exposures" from "service_role";

revoke delete on table "public"."ab_test_variants" from "anon";

revoke insert on table "public"."ab_test_variants" from "anon";

revoke references on table "public"."ab_test_variants" from "anon";

revoke select on table "public"."ab_test_variants" from "anon";

revoke trigger on table "public"."ab_test_variants" from "anon";

revoke truncate on table "public"."ab_test_variants" from "anon";

revoke update on table "public"."ab_test_variants" from "anon";

revoke delete on table "public"."ab_test_variants" from "authenticated";

revoke insert on table "public"."ab_test_variants" from "authenticated";

revoke references on table "public"."ab_test_variants" from "authenticated";

revoke select on table "public"."ab_test_variants" from "authenticated";

revoke trigger on table "public"."ab_test_variants" from "authenticated";

revoke truncate on table "public"."ab_test_variants" from "authenticated";

revoke update on table "public"."ab_test_variants" from "authenticated";

revoke delete on table "public"."ab_test_variants" from "service_role";

revoke insert on table "public"."ab_test_variants" from "service_role";

revoke references on table "public"."ab_test_variants" from "service_role";

revoke select on table "public"."ab_test_variants" from "service_role";

revoke trigger on table "public"."ab_test_variants" from "service_role";

revoke truncate on table "public"."ab_test_variants" from "service_role";

revoke update on table "public"."ab_test_variants" from "service_role";

revoke delete on table "public"."ab_tests" from "anon";

revoke insert on table "public"."ab_tests" from "anon";

revoke references on table "public"."ab_tests" from "anon";

revoke select on table "public"."ab_tests" from "anon";

revoke trigger on table "public"."ab_tests" from "anon";

revoke truncate on table "public"."ab_tests" from "anon";

revoke update on table "public"."ab_tests" from "anon";

revoke delete on table "public"."ab_tests" from "authenticated";

revoke insert on table "public"."ab_tests" from "authenticated";

revoke references on table "public"."ab_tests" from "authenticated";

revoke select on table "public"."ab_tests" from "authenticated";

revoke trigger on table "public"."ab_tests" from "authenticated";

revoke truncate on table "public"."ab_tests" from "authenticated";

revoke update on table "public"."ab_tests" from "authenticated";

revoke delete on table "public"."ab_tests" from "service_role";

revoke insert on table "public"."ab_tests" from "service_role";

revoke references on table "public"."ab_tests" from "service_role";

revoke select on table "public"."ab_tests" from "service_role";

revoke trigger on table "public"."ab_tests" from "service_role";

revoke truncate on table "public"."ab_tests" from "service_role";

revoke update on table "public"."ab_tests" from "service_role";

revoke delete on table "public"."app_builds" from "anon";

revoke insert on table "public"."app_builds" from "anon";

revoke references on table "public"."app_builds" from "anon";

revoke select on table "public"."app_builds" from "anon";

revoke trigger on table "public"."app_builds" from "anon";

revoke truncate on table "public"."app_builds" from "anon";

revoke update on table "public"."app_builds" from "anon";

revoke delete on table "public"."app_builds" from "authenticated";

revoke insert on table "public"."app_builds" from "authenticated";

revoke references on table "public"."app_builds" from "authenticated";

revoke select on table "public"."app_builds" from "authenticated";

revoke trigger on table "public"."app_builds" from "authenticated";

revoke truncate on table "public"."app_builds" from "authenticated";

revoke update on table "public"."app_builds" from "authenticated";

revoke delete on table "public"."app_builds" from "service_role";

revoke insert on table "public"."app_builds" from "service_role";

revoke references on table "public"."app_builds" from "service_role";

revoke select on table "public"."app_builds" from "service_role";

revoke trigger on table "public"."app_builds" from "service_role";

revoke truncate on table "public"."app_builds" from "service_role";

revoke update on table "public"."app_builds" from "service_role";

revoke delete on table "public"."app_configs" from "anon";

revoke insert on table "public"."app_configs" from "anon";

revoke references on table "public"."app_configs" from "anon";

revoke select on table "public"."app_configs" from "anon";

revoke trigger on table "public"."app_configs" from "anon";

revoke truncate on table "public"."app_configs" from "anon";

revoke update on table "public"."app_configs" from "anon";

revoke delete on table "public"."app_configs" from "authenticated";

revoke insert on table "public"."app_configs" from "authenticated";

revoke references on table "public"."app_configs" from "authenticated";

revoke select on table "public"."app_configs" from "authenticated";

revoke trigger on table "public"."app_configs" from "authenticated";

revoke truncate on table "public"."app_configs" from "authenticated";

revoke update on table "public"."app_configs" from "authenticated";

revoke delete on table "public"."app_configs" from "service_role";

revoke insert on table "public"."app_configs" from "service_role";

revoke references on table "public"."app_configs" from "service_role";

revoke select on table "public"."app_configs" from "service_role";

revoke trigger on table "public"."app_configs" from "service_role";

revoke truncate on table "public"."app_configs" from "service_role";

revoke update on table "public"."app_configs" from "service_role";

revoke delete on table "public"."banner_interactions" from "anon";

revoke insert on table "public"."banner_interactions" from "anon";

revoke references on table "public"."banner_interactions" from "anon";

revoke select on table "public"."banner_interactions" from "anon";

revoke trigger on table "public"."banner_interactions" from "anon";

revoke truncate on table "public"."banner_interactions" from "anon";

revoke update on table "public"."banner_interactions" from "anon";

revoke delete on table "public"."banner_interactions" from "authenticated";

revoke insert on table "public"."banner_interactions" from "authenticated";

revoke references on table "public"."banner_interactions" from "authenticated";

revoke select on table "public"."banner_interactions" from "authenticated";

revoke trigger on table "public"."banner_interactions" from "authenticated";

revoke truncate on table "public"."banner_interactions" from "authenticated";

revoke update on table "public"."banner_interactions" from "authenticated";

revoke delete on table "public"."banner_interactions" from "service_role";

revoke insert on table "public"."banner_interactions" from "service_role";

revoke references on table "public"."banner_interactions" from "service_role";

revoke select on table "public"."banner_interactions" from "service_role";

revoke trigger on table "public"."banner_interactions" from "service_role";

revoke truncate on table "public"."banner_interactions" from "service_role";

revoke update on table "public"."banner_interactions" from "service_role";

revoke delete on table "public"."brands" from "anon";

revoke insert on table "public"."brands" from "anon";

revoke references on table "public"."brands" from "anon";

revoke select on table "public"."brands" from "anon";

revoke trigger on table "public"."brands" from "anon";

revoke truncate on table "public"."brands" from "anon";

revoke update on table "public"."brands" from "anon";

revoke delete on table "public"."brands" from "authenticated";

revoke insert on table "public"."brands" from "authenticated";

revoke references on table "public"."brands" from "authenticated";

revoke select on table "public"."brands" from "authenticated";

revoke trigger on table "public"."brands" from "authenticated";

revoke truncate on table "public"."brands" from "authenticated";

revoke update on table "public"."brands" from "authenticated";

revoke delete on table "public"."brands" from "service_role";

revoke insert on table "public"."brands" from "service_role";

revoke references on table "public"."brands" from "service_role";

revoke select on table "public"."brands" from "service_role";

revoke trigger on table "public"."brands" from "service_role";

revoke truncate on table "public"."brands" from "service_role";

revoke update on table "public"."brands" from "service_role";

revoke delete on table "public"."coupon_templates" from "anon";

revoke insert on table "public"."coupon_templates" from "anon";

revoke references on table "public"."coupon_templates" from "anon";

revoke select on table "public"."coupon_templates" from "anon";

revoke trigger on table "public"."coupon_templates" from "anon";

revoke truncate on table "public"."coupon_templates" from "anon";

revoke update on table "public"."coupon_templates" from "anon";

revoke delete on table "public"."coupon_templates" from "authenticated";

revoke insert on table "public"."coupon_templates" from "authenticated";

revoke references on table "public"."coupon_templates" from "authenticated";

revoke select on table "public"."coupon_templates" from "authenticated";

revoke trigger on table "public"."coupon_templates" from "authenticated";

revoke truncate on table "public"."coupon_templates" from "authenticated";

revoke update on table "public"."coupon_templates" from "authenticated";

revoke delete on table "public"."coupon_templates" from "service_role";

revoke insert on table "public"."coupon_templates" from "service_role";

revoke references on table "public"."coupon_templates" from "service_role";

revoke select on table "public"."coupon_templates" from "service_role";

revoke trigger on table "public"."coupon_templates" from "service_role";

revoke truncate on table "public"."coupon_templates" from "service_role";

revoke update on table "public"."coupon_templates" from "service_role";

revoke delete on table "public"."coupons" from "anon";

revoke insert on table "public"."coupons" from "anon";

revoke references on table "public"."coupons" from "anon";

revoke select on table "public"."coupons" from "anon";

revoke trigger on table "public"."coupons" from "anon";

revoke truncate on table "public"."coupons" from "anon";

revoke update on table "public"."coupons" from "anon";

revoke delete on table "public"."coupons" from "authenticated";

revoke insert on table "public"."coupons" from "authenticated";

revoke references on table "public"."coupons" from "authenticated";

revoke select on table "public"."coupons" from "authenticated";

revoke trigger on table "public"."coupons" from "authenticated";

revoke truncate on table "public"."coupons" from "authenticated";

revoke update on table "public"."coupons" from "authenticated";

revoke delete on table "public"."coupons" from "service_role";

revoke insert on table "public"."coupons" from "service_role";

revoke references on table "public"."coupons" from "service_role";

revoke select on table "public"."coupons" from "service_role";

revoke trigger on table "public"."coupons" from "service_role";

revoke truncate on table "public"."coupons" from "service_role";

revoke update on table "public"."coupons" from "service_role";

revoke delete on table "public"."customer_segments" from "anon";

revoke insert on table "public"."customer_segments" from "anon";

revoke references on table "public"."customer_segments" from "anon";

revoke select on table "public"."customer_segments" from "anon";

revoke trigger on table "public"."customer_segments" from "anon";

revoke truncate on table "public"."customer_segments" from "anon";

revoke update on table "public"."customer_segments" from "anon";

revoke delete on table "public"."customer_segments" from "authenticated";

revoke insert on table "public"."customer_segments" from "authenticated";

revoke references on table "public"."customer_segments" from "authenticated";

revoke select on table "public"."customer_segments" from "authenticated";

revoke trigger on table "public"."customer_segments" from "authenticated";

revoke truncate on table "public"."customer_segments" from "authenticated";

revoke update on table "public"."customer_segments" from "authenticated";

revoke delete on table "public"."customer_segments" from "service_role";

revoke insert on table "public"."customer_segments" from "service_role";

revoke references on table "public"."customer_segments" from "service_role";

revoke select on table "public"."customer_segments" from "service_role";

revoke trigger on table "public"."customer_segments" from "service_role";

revoke truncate on table "public"."customer_segments" from "service_role";

revoke update on table "public"."customer_segments" from "service_role";

revoke delete on table "public"."customers" from "anon";

revoke insert on table "public"."customers" from "anon";

revoke references on table "public"."customers" from "anon";

revoke select on table "public"."customers" from "anon";

revoke trigger on table "public"."customers" from "anon";

revoke truncate on table "public"."customers" from "anon";

revoke update on table "public"."customers" from "anon";

revoke delete on table "public"."customers" from "authenticated";

revoke insert on table "public"."customers" from "authenticated";

revoke references on table "public"."customers" from "authenticated";

revoke select on table "public"."customers" from "authenticated";

revoke trigger on table "public"."customers" from "authenticated";

revoke truncate on table "public"."customers" from "authenticated";

revoke update on table "public"."customers" from "authenticated";

revoke delete on table "public"."customers" from "service_role";

revoke insert on table "public"."customers" from "service_role";

revoke references on table "public"."customers" from "service_role";

revoke select on table "public"."customers" from "service_role";

revoke trigger on table "public"."customers" from "service_role";

revoke truncate on table "public"."customers" from "service_role";

revoke update on table "public"."customers" from "service_role";

revoke delete on table "public"."inventory" from "anon";

revoke insert on table "public"."inventory" from "anon";

revoke references on table "public"."inventory" from "anon";

revoke select on table "public"."inventory" from "anon";

revoke trigger on table "public"."inventory" from "anon";

revoke truncate on table "public"."inventory" from "anon";

revoke update on table "public"."inventory" from "anon";

revoke delete on table "public"."inventory" from "authenticated";

revoke insert on table "public"."inventory" from "authenticated";

revoke references on table "public"."inventory" from "authenticated";

revoke select on table "public"."inventory" from "authenticated";

revoke trigger on table "public"."inventory" from "authenticated";

revoke truncate on table "public"."inventory" from "authenticated";

revoke update on table "public"."inventory" from "authenticated";

revoke delete on table "public"."inventory" from "service_role";

revoke insert on table "public"."inventory" from "service_role";

revoke references on table "public"."inventory" from "service_role";

revoke select on table "public"."inventory" from "service_role";

revoke trigger on table "public"."inventory" from "service_role";

revoke truncate on table "public"."inventory" from "service_role";

revoke update on table "public"."inventory" from "service_role";

revoke delete on table "public"."loyalty_transactions" from "anon";

revoke insert on table "public"."loyalty_transactions" from "anon";

revoke references on table "public"."loyalty_transactions" from "anon";

revoke select on table "public"."loyalty_transactions" from "anon";

revoke trigger on table "public"."loyalty_transactions" from "anon";

revoke truncate on table "public"."loyalty_transactions" from "anon";

revoke update on table "public"."loyalty_transactions" from "anon";

revoke delete on table "public"."loyalty_transactions" from "authenticated";

revoke insert on table "public"."loyalty_transactions" from "authenticated";

revoke references on table "public"."loyalty_transactions" from "authenticated";

revoke select on table "public"."loyalty_transactions" from "authenticated";

revoke trigger on table "public"."loyalty_transactions" from "authenticated";

revoke truncate on table "public"."loyalty_transactions" from "authenticated";

revoke update on table "public"."loyalty_transactions" from "authenticated";

revoke delete on table "public"."loyalty_transactions" from "service_role";

revoke insert on table "public"."loyalty_transactions" from "service_role";

revoke references on table "public"."loyalty_transactions" from "service_role";

revoke select on table "public"."loyalty_transactions" from "service_role";

revoke trigger on table "public"."loyalty_transactions" from "service_role";

revoke truncate on table "public"."loyalty_transactions" from "service_role";

revoke update on table "public"."loyalty_transactions" from "service_role";

revoke delete on table "public"."menu_categories" from "anon";

revoke insert on table "public"."menu_categories" from "anon";

revoke references on table "public"."menu_categories" from "anon";

revoke select on table "public"."menu_categories" from "anon";

revoke trigger on table "public"."menu_categories" from "anon";

revoke truncate on table "public"."menu_categories" from "anon";

revoke update on table "public"."menu_categories" from "anon";

revoke delete on table "public"."menu_categories" from "authenticated";

revoke insert on table "public"."menu_categories" from "authenticated";

revoke references on table "public"."menu_categories" from "authenticated";

revoke select on table "public"."menu_categories" from "authenticated";

revoke trigger on table "public"."menu_categories" from "authenticated";

revoke truncate on table "public"."menu_categories" from "authenticated";

revoke update on table "public"."menu_categories" from "authenticated";

revoke delete on table "public"."menu_categories" from "service_role";

revoke insert on table "public"."menu_categories" from "service_role";

revoke references on table "public"."menu_categories" from "service_role";

revoke select on table "public"."menu_categories" from "service_role";

revoke trigger on table "public"."menu_categories" from "service_role";

revoke truncate on table "public"."menu_categories" from "service_role";

revoke update on table "public"."menu_categories" from "service_role";

revoke delete on table "public"."menu_items" from "anon";

revoke insert on table "public"."menu_items" from "anon";

revoke references on table "public"."menu_items" from "anon";

revoke select on table "public"."menu_items" from "anon";

revoke trigger on table "public"."menu_items" from "anon";

revoke truncate on table "public"."menu_items" from "anon";

revoke update on table "public"."menu_items" from "anon";

revoke delete on table "public"."menu_items" from "authenticated";

revoke insert on table "public"."menu_items" from "authenticated";

revoke references on table "public"."menu_items" from "authenticated";

revoke select on table "public"."menu_items" from "authenticated";

revoke trigger on table "public"."menu_items" from "authenticated";

revoke truncate on table "public"."menu_items" from "authenticated";

revoke update on table "public"."menu_items" from "authenticated";

revoke delete on table "public"."menu_items" from "service_role";

revoke insert on table "public"."menu_items" from "service_role";

revoke references on table "public"."menu_items" from "service_role";

revoke select on table "public"."menu_items" from "service_role";

revoke trigger on table "public"."menu_items" from "service_role";

revoke truncate on table "public"."menu_items" from "service_role";

revoke update on table "public"."menu_items" from "service_role";

revoke delete on table "public"."menu_modifiers" from "anon";

revoke insert on table "public"."menu_modifiers" from "anon";

revoke references on table "public"."menu_modifiers" from "anon";

revoke select on table "public"."menu_modifiers" from "anon";

revoke trigger on table "public"."menu_modifiers" from "anon";

revoke truncate on table "public"."menu_modifiers" from "anon";

revoke update on table "public"."menu_modifiers" from "anon";

revoke delete on table "public"."menu_modifiers" from "authenticated";

revoke insert on table "public"."menu_modifiers" from "authenticated";

revoke references on table "public"."menu_modifiers" from "authenticated";

revoke select on table "public"."menu_modifiers" from "authenticated";

revoke trigger on table "public"."menu_modifiers" from "authenticated";

revoke truncate on table "public"."menu_modifiers" from "authenticated";

revoke update on table "public"."menu_modifiers" from "authenticated";

revoke delete on table "public"."menu_modifiers" from "service_role";

revoke insert on table "public"."menu_modifiers" from "service_role";

revoke references on table "public"."menu_modifiers" from "service_role";

revoke select on table "public"."menu_modifiers" from "service_role";

revoke trigger on table "public"."menu_modifiers" from "service_role";

revoke truncate on table "public"."menu_modifiers" from "service_role";

revoke update on table "public"."menu_modifiers" from "service_role";

revoke delete on table "public"."menu_schedules" from "anon";

revoke insert on table "public"."menu_schedules" from "anon";

revoke references on table "public"."menu_schedules" from "anon";

revoke select on table "public"."menu_schedules" from "anon";

revoke trigger on table "public"."menu_schedules" from "anon";

revoke truncate on table "public"."menu_schedules" from "anon";

revoke update on table "public"."menu_schedules" from "anon";

revoke delete on table "public"."menu_schedules" from "authenticated";

revoke insert on table "public"."menu_schedules" from "authenticated";

revoke references on table "public"."menu_schedules" from "authenticated";

revoke select on table "public"."menu_schedules" from "authenticated";

revoke trigger on table "public"."menu_schedules" from "authenticated";

revoke truncate on table "public"."menu_schedules" from "authenticated";

revoke update on table "public"."menu_schedules" from "authenticated";

revoke delete on table "public"."menu_schedules" from "service_role";

revoke insert on table "public"."menu_schedules" from "service_role";

revoke references on table "public"."menu_schedules" from "service_role";

revoke select on table "public"."menu_schedules" from "service_role";

revoke trigger on table "public"."menu_schedules" from "service_role";

revoke truncate on table "public"."menu_schedules" from "service_role";

revoke update on table "public"."menu_schedules" from "service_role";

revoke delete on table "public"."notification_logs" from "anon";

revoke insert on table "public"."notification_logs" from "anon";

revoke references on table "public"."notification_logs" from "anon";

revoke select on table "public"."notification_logs" from "anon";

revoke trigger on table "public"."notification_logs" from "anon";

revoke truncate on table "public"."notification_logs" from "anon";

revoke update on table "public"."notification_logs" from "anon";

revoke delete on table "public"."notification_logs" from "authenticated";

revoke insert on table "public"."notification_logs" from "authenticated";

revoke references on table "public"."notification_logs" from "authenticated";

revoke select on table "public"."notification_logs" from "authenticated";

revoke trigger on table "public"."notification_logs" from "authenticated";

revoke truncate on table "public"."notification_logs" from "authenticated";

revoke update on table "public"."notification_logs" from "authenticated";

revoke delete on table "public"."notification_logs" from "service_role";

revoke insert on table "public"."notification_logs" from "service_role";

revoke references on table "public"."notification_logs" from "service_role";

revoke select on table "public"."notification_logs" from "service_role";

revoke trigger on table "public"."notification_logs" from "service_role";

revoke truncate on table "public"."notification_logs" from "service_role";

revoke update on table "public"."notification_logs" from "service_role";

revoke delete on table "public"."notification_templates" from "anon";

revoke insert on table "public"."notification_templates" from "anon";

revoke references on table "public"."notification_templates" from "anon";

revoke select on table "public"."notification_templates" from "anon";

revoke trigger on table "public"."notification_templates" from "anon";

revoke truncate on table "public"."notification_templates" from "anon";

revoke update on table "public"."notification_templates" from "anon";

revoke delete on table "public"."notification_templates" from "authenticated";

revoke insert on table "public"."notification_templates" from "authenticated";

revoke references on table "public"."notification_templates" from "authenticated";

revoke select on table "public"."notification_templates" from "authenticated";

revoke trigger on table "public"."notification_templates" from "authenticated";

revoke truncate on table "public"."notification_templates" from "authenticated";

revoke update on table "public"."notification_templates" from "authenticated";

revoke delete on table "public"."notification_templates" from "service_role";

revoke insert on table "public"."notification_templates" from "service_role";

revoke references on table "public"."notification_templates" from "service_role";

revoke select on table "public"."notification_templates" from "service_role";

revoke trigger on table "public"."notification_templates" from "service_role";

revoke truncate on table "public"."notification_templates" from "service_role";

revoke update on table "public"."notification_templates" from "service_role";

revoke delete on table "public"."notifications" from "anon";

revoke insert on table "public"."notifications" from "anon";

revoke references on table "public"."notifications" from "anon";

revoke select on table "public"."notifications" from "anon";

revoke trigger on table "public"."notifications" from "anon";

revoke truncate on table "public"."notifications" from "anon";

revoke update on table "public"."notifications" from "anon";

revoke delete on table "public"."notifications" from "authenticated";

revoke insert on table "public"."notifications" from "authenticated";

revoke references on table "public"."notifications" from "authenticated";

revoke select on table "public"."notifications" from "authenticated";

revoke trigger on table "public"."notifications" from "authenticated";

revoke truncate on table "public"."notifications" from "authenticated";

revoke update on table "public"."notifications" from "authenticated";

revoke delete on table "public"."notifications" from "service_role";

revoke insert on table "public"."notifications" from "service_role";

revoke references on table "public"."notifications" from "service_role";

revoke select on table "public"."notifications" from "service_role";

revoke trigger on table "public"."notifications" from "service_role";

revoke truncate on table "public"."notifications" from "service_role";

revoke update on table "public"."notifications" from "service_role";

revoke delete on table "public"."order_status_history" from "anon";

revoke insert on table "public"."order_status_history" from "anon";

revoke references on table "public"."order_status_history" from "anon";

revoke select on table "public"."order_status_history" from "anon";

revoke trigger on table "public"."order_status_history" from "anon";

revoke truncate on table "public"."order_status_history" from "anon";

revoke update on table "public"."order_status_history" from "anon";

revoke delete on table "public"."order_status_history" from "authenticated";

revoke insert on table "public"."order_status_history" from "authenticated";

revoke references on table "public"."order_status_history" from "authenticated";

revoke select on table "public"."order_status_history" from "authenticated";

revoke trigger on table "public"."order_status_history" from "authenticated";

revoke truncate on table "public"."order_status_history" from "authenticated";

revoke update on table "public"."order_status_history" from "authenticated";

revoke delete on table "public"."order_status_history" from "service_role";

revoke insert on table "public"."order_status_history" from "service_role";

revoke references on table "public"."order_status_history" from "service_role";

revoke select on table "public"."order_status_history" from "service_role";

revoke trigger on table "public"."order_status_history" from "service_role";

revoke truncate on table "public"."order_status_history" from "service_role";

revoke update on table "public"."order_status_history" from "service_role";

revoke delete on table "public"."orders" from "anon";

revoke insert on table "public"."orders" from "anon";

revoke references on table "public"."orders" from "anon";

revoke select on table "public"."orders" from "anon";

revoke trigger on table "public"."orders" from "anon";

revoke truncate on table "public"."orders" from "anon";

revoke update on table "public"."orders" from "anon";

revoke delete on table "public"."orders" from "authenticated";

revoke insert on table "public"."orders" from "authenticated";

revoke references on table "public"."orders" from "authenticated";

revoke select on table "public"."orders" from "authenticated";

revoke trigger on table "public"."orders" from "authenticated";

revoke truncate on table "public"."orders" from "authenticated";

revoke update on table "public"."orders" from "authenticated";

revoke delete on table "public"."orders" from "service_role";

revoke insert on table "public"."orders" from "service_role";

revoke references on table "public"."orders" from "service_role";

revoke select on table "public"."orders" from "service_role";

revoke trigger on table "public"."orders" from "service_role";

revoke truncate on table "public"."orders" from "service_role";

revoke update on table "public"."orders" from "service_role";

revoke delete on table "public"."pickup_reservations" from "anon";

revoke insert on table "public"."pickup_reservations" from "anon";

revoke references on table "public"."pickup_reservations" from "anon";

revoke select on table "public"."pickup_reservations" from "anon";

revoke trigger on table "public"."pickup_reservations" from "anon";

revoke truncate on table "public"."pickup_reservations" from "anon";

revoke update on table "public"."pickup_reservations" from "anon";

revoke delete on table "public"."pickup_reservations" from "authenticated";

revoke insert on table "public"."pickup_reservations" from "authenticated";

revoke references on table "public"."pickup_reservations" from "authenticated";

revoke select on table "public"."pickup_reservations" from "authenticated";

revoke trigger on table "public"."pickup_reservations" from "authenticated";

revoke truncate on table "public"."pickup_reservations" from "authenticated";

revoke update on table "public"."pickup_reservations" from "authenticated";

revoke delete on table "public"."pickup_reservations" from "service_role";

revoke insert on table "public"."pickup_reservations" from "service_role";

revoke references on table "public"."pickup_reservations" from "service_role";

revoke select on table "public"."pickup_reservations" from "service_role";

revoke trigger on table "public"."pickup_reservations" from "service_role";

revoke truncate on table "public"."pickup_reservations" from "service_role";

revoke update on table "public"."pickup_reservations" from "service_role";

revoke delete on table "public"."pickup_slots" from "anon";

revoke insert on table "public"."pickup_slots" from "anon";

revoke references on table "public"."pickup_slots" from "anon";

revoke select on table "public"."pickup_slots" from "anon";

revoke trigger on table "public"."pickup_slots" from "anon";

revoke truncate on table "public"."pickup_slots" from "anon";

revoke update on table "public"."pickup_slots" from "anon";

revoke delete on table "public"."pickup_slots" from "authenticated";

revoke insert on table "public"."pickup_slots" from "authenticated";

revoke references on table "public"."pickup_slots" from "authenticated";

revoke select on table "public"."pickup_slots" from "authenticated";

revoke trigger on table "public"."pickup_slots" from "authenticated";

revoke truncate on table "public"."pickup_slots" from "authenticated";

revoke update on table "public"."pickup_slots" from "authenticated";

revoke delete on table "public"."pickup_slots" from "service_role";

revoke insert on table "public"."pickup_slots" from "service_role";

revoke references on table "public"."pickup_slots" from "service_role";

revoke select on table "public"."pickup_slots" from "service_role";

revoke trigger on table "public"."pickup_slots" from "service_role";

revoke truncate on table "public"."pickup_slots" from "service_role";

revoke update on table "public"."pickup_slots" from "service_role";

revoke delete on table "public"."promotion_banners" from "anon";

revoke insert on table "public"."promotion_banners" from "anon";

revoke references on table "public"."promotion_banners" from "anon";

revoke select on table "public"."promotion_banners" from "anon";

revoke trigger on table "public"."promotion_banners" from "anon";

revoke truncate on table "public"."promotion_banners" from "anon";

revoke update on table "public"."promotion_banners" from "anon";

revoke delete on table "public"."promotion_banners" from "authenticated";

revoke insert on table "public"."promotion_banners" from "authenticated";

revoke references on table "public"."promotion_banners" from "authenticated";

revoke select on table "public"."promotion_banners" from "authenticated";

revoke trigger on table "public"."promotion_banners" from "authenticated";

revoke truncate on table "public"."promotion_banners" from "authenticated";

revoke update on table "public"."promotion_banners" from "authenticated";

revoke delete on table "public"."promotion_banners" from "service_role";

revoke insert on table "public"."promotion_banners" from "service_role";

revoke references on table "public"."promotion_banners" from "service_role";

revoke select on table "public"."promotion_banners" from "service_role";

revoke trigger on table "public"."promotion_banners" from "service_role";

revoke truncate on table "public"."promotion_banners" from "service_role";

revoke update on table "public"."promotion_banners" from "service_role";

revoke delete on table "public"."promotions" from "anon";

revoke insert on table "public"."promotions" from "anon";

revoke references on table "public"."promotions" from "anon";

revoke select on table "public"."promotions" from "anon";

revoke trigger on table "public"."promotions" from "anon";

revoke truncate on table "public"."promotions" from "anon";

revoke update on table "public"."promotions" from "anon";

revoke delete on table "public"."promotions" from "authenticated";

revoke insert on table "public"."promotions" from "authenticated";

revoke references on table "public"."promotions" from "authenticated";

revoke select on table "public"."promotions" from "authenticated";

revoke trigger on table "public"."promotions" from "authenticated";

revoke truncate on table "public"."promotions" from "authenticated";

revoke update on table "public"."promotions" from "authenticated";

revoke delete on table "public"."promotions" from "service_role";

revoke insert on table "public"."promotions" from "service_role";

revoke references on table "public"."promotions" from "service_role";

revoke select on table "public"."promotions" from "service_role";

revoke trigger on table "public"."promotions" from "service_role";

revoke truncate on table "public"."promotions" from "service_role";

revoke update on table "public"."promotions" from "service_role";

revoke delete on table "public"."push_tokens" from "anon";

revoke insert on table "public"."push_tokens" from "anon";

revoke references on table "public"."push_tokens" from "anon";

revoke select on table "public"."push_tokens" from "anon";

revoke trigger on table "public"."push_tokens" from "anon";

revoke truncate on table "public"."push_tokens" from "anon";

revoke update on table "public"."push_tokens" from "anon";

revoke delete on table "public"."push_tokens" from "authenticated";

revoke insert on table "public"."push_tokens" from "authenticated";

revoke references on table "public"."push_tokens" from "authenticated";

revoke select on table "public"."push_tokens" from "authenticated";

revoke trigger on table "public"."push_tokens" from "authenticated";

revoke truncate on table "public"."push_tokens" from "authenticated";

revoke update on table "public"."push_tokens" from "authenticated";

revoke delete on table "public"."push_tokens" from "service_role";

revoke insert on table "public"."push_tokens" from "service_role";

revoke references on table "public"."push_tokens" from "service_role";

revoke select on table "public"."push_tokens" from "service_role";

revoke trigger on table "public"."push_tokens" from "service_role";

revoke truncate on table "public"."push_tokens" from "service_role";

revoke update on table "public"."push_tokens" from "service_role";

revoke delete on table "public"."recommended_menu_configs" from "anon";

revoke insert on table "public"."recommended_menu_configs" from "anon";

revoke references on table "public"."recommended_menu_configs" from "anon";

revoke select on table "public"."recommended_menu_configs" from "anon";

revoke trigger on table "public"."recommended_menu_configs" from "anon";

revoke truncate on table "public"."recommended_menu_configs" from "anon";

revoke update on table "public"."recommended_menu_configs" from "anon";

revoke delete on table "public"."recommended_menu_configs" from "authenticated";

revoke insert on table "public"."recommended_menu_configs" from "authenticated";

revoke references on table "public"."recommended_menu_configs" from "authenticated";

revoke select on table "public"."recommended_menu_configs" from "authenticated";

revoke trigger on table "public"."recommended_menu_configs" from "authenticated";

revoke truncate on table "public"."recommended_menu_configs" from "authenticated";

revoke update on table "public"."recommended_menu_configs" from "authenticated";

revoke delete on table "public"."recommended_menu_configs" from "service_role";

revoke insert on table "public"."recommended_menu_configs" from "service_role";

revoke references on table "public"."recommended_menu_configs" from "service_role";

revoke select on table "public"."recommended_menu_configs" from "service_role";

revoke trigger on table "public"."recommended_menu_configs" from "service_role";

revoke truncate on table "public"."recommended_menu_configs" from "service_role";

revoke update on table "public"."recommended_menu_configs" from "service_role";

revoke delete on table "public"."refunds" from "anon";

revoke insert on table "public"."refunds" from "anon";

revoke references on table "public"."refunds" from "anon";

revoke select on table "public"."refunds" from "anon";

revoke trigger on table "public"."refunds" from "anon";

revoke truncate on table "public"."refunds" from "anon";

revoke update on table "public"."refunds" from "anon";

revoke delete on table "public"."refunds" from "authenticated";

revoke insert on table "public"."refunds" from "authenticated";

revoke references on table "public"."refunds" from "authenticated";

revoke select on table "public"."refunds" from "authenticated";

revoke trigger on table "public"."refunds" from "authenticated";

revoke truncate on table "public"."refunds" from "authenticated";

revoke update on table "public"."refunds" from "authenticated";

revoke delete on table "public"."refunds" from "service_role";

revoke insert on table "public"."refunds" from "service_role";

revoke references on table "public"."refunds" from "service_role";

revoke select on table "public"."refunds" from "service_role";

revoke trigger on table "public"."refunds" from "service_role";

revoke truncate on table "public"."refunds" from "service_role";

revoke update on table "public"."refunds" from "service_role";

revoke delete on table "public"."staff" from "anon";

revoke insert on table "public"."staff" from "anon";

revoke references on table "public"."staff" from "anon";

revoke select on table "public"."staff" from "anon";

revoke trigger on table "public"."staff" from "anon";

revoke truncate on table "public"."staff" from "anon";

revoke update on table "public"."staff" from "anon";

revoke delete on table "public"."staff" from "authenticated";

revoke insert on table "public"."staff" from "authenticated";

revoke references on table "public"."staff" from "authenticated";

revoke select on table "public"."staff" from "authenticated";

revoke trigger on table "public"."staff" from "authenticated";

revoke truncate on table "public"."staff" from "authenticated";

revoke update on table "public"."staff" from "authenticated";

revoke delete on table "public"."staff" from "service_role";

revoke insert on table "public"."staff" from "service_role";

revoke references on table "public"."staff" from "service_role";

revoke select on table "public"."staff" from "service_role";

revoke trigger on table "public"."staff" from "service_role";

revoke truncate on table "public"."staff" from "service_role";

revoke update on table "public"."staff" from "service_role";

revoke delete on table "public"."stamp_cards" from "anon";

revoke insert on table "public"."stamp_cards" from "anon";

revoke references on table "public"."stamp_cards" from "anon";

revoke select on table "public"."stamp_cards" from "anon";

revoke trigger on table "public"."stamp_cards" from "anon";

revoke truncate on table "public"."stamp_cards" from "anon";

revoke update on table "public"."stamp_cards" from "anon";

revoke delete on table "public"."stamp_cards" from "authenticated";

revoke insert on table "public"."stamp_cards" from "authenticated";

revoke references on table "public"."stamp_cards" from "authenticated";

revoke select on table "public"."stamp_cards" from "authenticated";

revoke trigger on table "public"."stamp_cards" from "authenticated";

revoke truncate on table "public"."stamp_cards" from "authenticated";

revoke update on table "public"."stamp_cards" from "authenticated";

revoke delete on table "public"."stamp_cards" from "service_role";

revoke insert on table "public"."stamp_cards" from "service_role";

revoke references on table "public"."stamp_cards" from "service_role";

revoke select on table "public"."stamp_cards" from "service_role";

revoke trigger on table "public"."stamp_cards" from "service_role";

revoke truncate on table "public"."stamp_cards" from "service_role";

revoke update on table "public"."stamp_cards" from "service_role";

revoke delete on table "public"."stores" from "anon";

revoke insert on table "public"."stores" from "anon";

revoke references on table "public"."stores" from "anon";

revoke select on table "public"."stores" from "anon";

revoke trigger on table "public"."stores" from "anon";

revoke truncate on table "public"."stores" from "anon";

revoke update on table "public"."stores" from "anon";

revoke delete on table "public"."stores" from "authenticated";

revoke insert on table "public"."stores" from "authenticated";

revoke references on table "public"."stores" from "authenticated";

revoke select on table "public"."stores" from "authenticated";

revoke trigger on table "public"."stores" from "authenticated";

revoke truncate on table "public"."stores" from "authenticated";

revoke update on table "public"."stores" from "authenticated";

revoke delete on table "public"."stores" from "service_role";

revoke insert on table "public"."stores" from "service_role";

revoke references on table "public"."stores" from "service_role";

revoke select on table "public"."stores" from "service_role";

revoke trigger on table "public"."stores" from "service_role";

revoke truncate on table "public"."stores" from "service_role";

revoke update on table "public"."stores" from "service_role";

revoke delete on table "public"."subscriptions" from "anon";

revoke insert on table "public"."subscriptions" from "anon";

revoke references on table "public"."subscriptions" from "anon";

revoke select on table "public"."subscriptions" from "anon";

revoke trigger on table "public"."subscriptions" from "anon";

revoke truncate on table "public"."subscriptions" from "anon";

revoke update on table "public"."subscriptions" from "anon";

revoke delete on table "public"."subscriptions" from "authenticated";

revoke insert on table "public"."subscriptions" from "authenticated";

revoke references on table "public"."subscriptions" from "authenticated";

revoke select on table "public"."subscriptions" from "authenticated";

revoke trigger on table "public"."subscriptions" from "authenticated";

revoke truncate on table "public"."subscriptions" from "authenticated";

revoke update on table "public"."subscriptions" from "authenticated";

revoke delete on table "public"."subscriptions" from "service_role";

revoke insert on table "public"."subscriptions" from "service_role";

revoke references on table "public"."subscriptions" from "service_role";

revoke select on table "public"."subscriptions" from "service_role";

revoke trigger on table "public"."subscriptions" from "service_role";

revoke truncate on table "public"."subscriptions" from "service_role";

revoke update on table "public"."subscriptions" from "service_role";

alter table "public"."ab_test_conversions" drop constraint "ab_test_conversions_coupon_id_fkey";

alter table "public"."ab_test_conversions" drop constraint "ab_test_conversions_customer_id_fkey";

alter table "public"."ab_test_conversions" drop constraint "ab_test_conversions_exposure_id_fkey";

alter table "public"."ab_test_conversions" drop constraint "ab_test_conversions_order_id_fkey";

alter table "public"."ab_test_conversions" drop constraint "ab_test_conversions_test_id_fkey";

alter table "public"."ab_test_exposures" drop constraint "ab_test_exposures_customer_id_fkey";

alter table "public"."ab_test_exposures" drop constraint "ab_test_exposures_test_id_fkey";

alter table "public"."ab_test_variants" drop constraint "ab_test_variants_banner_id_fkey";

alter table "public"."ab_test_variants" drop constraint "ab_test_variants_coupon_template_id_fkey";

alter table "public"."ab_test_variants" drop constraint "ab_test_variants_test_id_fkey";

alter table "public"."ab_tests" drop constraint "ab_tests_brand_id_fkey";

alter table "public"."ab_tests" drop constraint "ab_tests_target_segment_id_fkey";

alter table "public"."app_builds" drop constraint "app_builds_app_config_id_fkey";

alter table "public"."app_builds" drop constraint "app_builds_completed_has_download";

alter table "public"."app_configs" drop constraint "app_configs_brand_id_fkey";

alter table "public"."banner_interactions" drop constraint "banner_interactions_banner_id_fkey";

alter table "public"."banner_interactions" drop constraint "banner_interactions_customer_id_fkey";

alter table "public"."coupon_templates" drop constraint "coupon_templates_brand_id_fkey";

alter table "public"."coupons" drop constraint "coupons_brand_id_fkey";

alter table "public"."coupons" drop constraint "coupons_customer_id_fkey";

alter table "public"."coupons" drop constraint "coupons_order_id_fkey";

alter table "public"."customer_segments" drop constraint "customer_segments_auto_has_conditions";

alter table "public"."customer_segments" drop constraint "customer_segments_brand_id_fkey";

alter table "public"."customers" drop constraint "customers_brand_id_fkey";

alter table "public"."inventory" drop constraint "inventory_item_id_fkey";

alter table "public"."inventory" drop constraint "inventory_store_id_fkey";

alter table "public"."loyalty_transactions" drop constraint "loyalty_transactions_brand_id_fkey";

alter table "public"."loyalty_transactions" drop constraint "loyalty_transactions_customer_id_fkey";

alter table "public"."loyalty_transactions" drop constraint "loyalty_transactions_order_id_fkey";

alter table "public"."menu_categories" drop constraint "menu_categories_brand_id_fkey";

alter table "public"."menu_categories" drop constraint "menu_categories_parent_id_fkey";

alter table "public"."menu_categories" drop constraint "menu_categories_store_id_fkey";

alter table "public"."menu_items" drop constraint "menu_items_brand_id_fkey";

alter table "public"."menu_items" drop constraint "menu_items_category_id_fkey";

alter table "public"."menu_items" drop constraint "menu_items_store_id_fkey";

alter table "public"."menu_modifiers" drop constraint "menu_modifiers_item_id_fkey";

alter table "public"."menu_schedules" drop constraint "menu_schedules_menu_item_id_fkey";

alter table "public"."notification_logs" drop constraint "notification_logs_customer_id_fkey";

alter table "public"."notification_logs" drop constraint "notification_logs_order_id_fkey";

alter table "public"."notification_templates" drop constraint "notification_templates_brand_id_fkey";

alter table "public"."notifications" drop constraint "notifications_brand_id_fkey";

alter table "public"."notifications" drop constraint "notifications_individual_target_has_customers";

alter table "public"."notifications" drop constraint "notifications_segment_id_fkey";

alter table "public"."notifications" drop constraint "notifications_segment_target_has_segment";

alter table "public"."order_status_history" drop constraint "order_status_history_order_id_fkey";

alter table "public"."orders" drop constraint "orders_brand_id_fkey";

alter table "public"."orders" drop constraint "orders_customer_id_fkey";

alter table "public"."orders" drop constraint "orders_store_id_fkey";

alter table "public"."pickup_reservations" drop constraint "pickup_reservations_customer_id_fkey";

alter table "public"."pickup_reservations" drop constraint "pickup_reservations_store_id_fkey";

alter table "public"."pickup_slots" drop constraint "pickup_slots_store_id_fkey";

alter table "public"."promotion_banners" drop constraint "promotion_banners_brand_id_fkey";

alter table "public"."promotions" drop constraint "promotions_brand_id_fkey";

alter table "public"."push_tokens" drop constraint "push_tokens_customer_id_fkey";

alter table "public"."recommended_menu_configs" drop constraint "recommended_menu_configs_brand_id_fkey";

alter table "public"."refunds" drop constraint "refunds_order_id_fkey";

alter table "public"."staff" drop constraint "staff_store_id_fkey";

alter table "public"."stamp_cards" drop constraint "stamp_cards_brand_id_fkey";

alter table "public"."stamp_cards" drop constraint "stamp_cards_customer_id_fkey";

alter table "public"."stores" drop constraint "stores_brand_id_fkey";

alter table "public"."subscriptions" drop constraint "subscriptions_brand_id_fkey";

drop index if exists "public"."idx_notification_logs_next_retry";

drop index if exists "public"."idx_notifications_scheduled_at";

drop index if exists "public"."idx_orders_active";

drop index if exists "public"."idx_stores_last_heartbeat";

drop index if exists "public"."idx_stores_location";

drop index if exists "public"."idx_subscriptions_expires_at";

alter table "public"."app_builds" alter column "platform" set data type public.build_platform using "platform"::text::public.build_platform;

alter table "public"."app_builds" alter column "status" set default 'in_progress'::public.build_status;

alter table "public"."app_builds" alter column "status" set data type public.build_status using "status"::text::public.build_status;

alter table "public"."coupon_templates" alter column "type" set data type public.coupon_type using "type"::text::public.coupon_type;

alter table "public"."coupons" alter column "type" set data type public.coupon_type using "type"::text::public.coupon_type;

alter table "public"."customer_segments" alter column "type" set default 'manual'::public.segment_type;

alter table "public"."customer_segments" alter column "type" set data type public.segment_type using "type"::text::public.segment_type;

alter table "public"."menu_modifiers" alter column "type" set default 'single'::public.modifier_type;

alter table "public"."menu_modifiers" alter column "type" set data type public.modifier_type using "type"::text::public.modifier_type;

alter table "public"."notification_logs" alter column "status" set default 'pending'::public.notification_status;

alter table "public"."notification_logs" alter column "status" set data type public.notification_status using "status"::text::public.notification_status;

alter table "public"."notification_logs" alter column "type" set data type public.notification_type using "type"::text::public.notification_type;

alter table "public"."notification_templates" alter column "category" set data type public.notification_category using "category"::text::public.notification_category;

alter table "public"."notifications" alter column "category" set data type public.notification_category using "category"::text::public.notification_category;

alter table "public"."notifications" alter column "status" set default 'draft'::public.notification_campaign_status;

alter table "public"."notifications" alter column "status" set data type public.notification_campaign_status using "status"::text::public.notification_campaign_status;

alter table "public"."notifications" alter column "target" set data type public.notification_target using "target"::text::public.notification_target;

alter table "public"."order_status_history" alter column "from_status" set data type public.order_status using "from_status"::text::public.order_status;

alter table "public"."order_status_history" alter column "to_status" set data type public.order_status using "to_status"::text::public.order_status;

alter table "public"."orders" alter column "payment_method" set data type public.payment_method using "payment_method"::text::public.payment_method;

alter table "public"."orders" alter column "payment_status" set default 'pending'::public.payment_status;

alter table "public"."orders" alter column "payment_status" set data type public.payment_status using "payment_status"::text::public.payment_status;

alter table "public"."orders" alter column "status" set default 'pending'::public.order_status;

alter table "public"."orders" alter column "status" set data type public.order_status using "status"::text::public.order_status;

alter table "public"."promotions" alter column "type" set data type public.promotion_type using "type"::text::public.promotion_type;

alter table "public"."recommended_menu_configs" alter column "auto_criteria" set default 'popular'::public.auto_criteria;

alter table "public"."recommended_menu_configs" alter column "auto_criteria" set data type public.auto_criteria using "auto_criteria"::text::public.auto_criteria;

alter table "public"."recommended_menu_configs" alter column "mode" set default 'auto'::public.recommendation_mode;

alter table "public"."recommended_menu_configs" alter column "mode" set data type public.recommendation_mode using "mode"::text::public.recommendation_mode;

alter table "public"."refunds" alter column "reason" set data type public.cancellation_reason using "reason"::text::public.cancellation_reason;

alter table "public"."refunds" alter column "status" set default 'pending'::public.refund_status;

alter table "public"."refunds" alter column "status" set data type public.refund_status using "status"::text::public.refund_status;

alter table "public"."staff" alter column "role" set default 'store_staff'::public.staff_role;

alter table "public"."staff" alter column "role" set data type public.staff_role using "role"::text::public.staff_role;

alter table "public"."staff" alter column "user_id" drop not null;

alter table "public"."stores" alter column "business_type" set data type public.business_type using "business_type"::text::public.business_type;

alter table "public"."stores" alter column "status" set default 'active'::public.store_status;

alter table "public"."stores" alter column "status" set data type public.store_status using "status"::text::public.store_status;

alter table "public"."subscriptions" alter column "plan" set default 'trial'::public.subscription_plan;

alter table "public"."subscriptions" alter column "plan" set data type public.subscription_plan using "plan"::text::public.subscription_plan;

alter table "public"."subscriptions" alter column "status" set default 'active'::public.subscription_status;

alter table "public"."subscriptions" alter column "status" set data type public.subscription_status using "status"::text::public.subscription_status;

CREATE INDEX idx_notification_logs_next_retry ON public.notification_logs USING btree (next_retry_at) WHERE ((status = 'failed'::public.notification_status) AND (next_retry_at IS NOT NULL));

CREATE INDEX idx_notifications_scheduled_at ON public.notifications USING btree (scheduled_at) WHERE (status = 'scheduled'::public.notification_campaign_status);

CREATE INDEX idx_orders_active ON public.orders USING btree (store_id, status) WHERE (status = ANY (ARRAY['waiting'::public.order_status, 'preparing'::public.order_status, 'ready'::public.order_status]));

CREATE INDEX idx_stores_last_heartbeat ON public.stores USING btree (last_heartbeat_at) WHERE (status <> 'offline'::public.store_status);

CREATE INDEX idx_stores_location ON public.stores USING gist (extensions.st_makepoint(lng, lat)) WHERE ((lat IS NOT NULL) AND (lng IS NOT NULL));

CREATE INDEX idx_subscriptions_expires_at ON public.subscriptions USING btree (expires_at) WHERE (status = 'active'::public.subscription_status);

alter table "public"."ab_test_conversions" add constraint "ab_test_conversions_coupon_id_fkey" FOREIGN KEY (coupon_id) REFERENCES public.coupons(id) ON DELETE SET NULL not valid;

alter table "public"."ab_test_conversions" validate constraint "ab_test_conversions_coupon_id_fkey";

alter table "public"."ab_test_conversions" add constraint "ab_test_conversions_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE not valid;

alter table "public"."ab_test_conversions" validate constraint "ab_test_conversions_customer_id_fkey";

alter table "public"."ab_test_conversions" add constraint "ab_test_conversions_exposure_id_fkey" FOREIGN KEY (exposure_id) REFERENCES public.ab_test_exposures(id) ON DELETE CASCADE not valid;

alter table "public"."ab_test_conversions" validate constraint "ab_test_conversions_exposure_id_fkey";

alter table "public"."ab_test_conversions" add constraint "ab_test_conversions_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL not valid;

alter table "public"."ab_test_conversions" validate constraint "ab_test_conversions_order_id_fkey";

alter table "public"."ab_test_conversions" add constraint "ab_test_conversions_test_id_fkey" FOREIGN KEY (test_id) REFERENCES public.ab_tests(id) ON DELETE CASCADE not valid;

alter table "public"."ab_test_conversions" validate constraint "ab_test_conversions_test_id_fkey";

alter table "public"."ab_test_exposures" add constraint "ab_test_exposures_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE not valid;

alter table "public"."ab_test_exposures" validate constraint "ab_test_exposures_customer_id_fkey";

alter table "public"."ab_test_exposures" add constraint "ab_test_exposures_test_id_fkey" FOREIGN KEY (test_id) REFERENCES public.ab_tests(id) ON DELETE CASCADE not valid;

alter table "public"."ab_test_exposures" validate constraint "ab_test_exposures_test_id_fkey";

alter table "public"."ab_test_variants" add constraint "ab_test_variants_banner_id_fkey" FOREIGN KEY (banner_id) REFERENCES public.promotion_banners(id) ON DELETE CASCADE not valid;

alter table "public"."ab_test_variants" validate constraint "ab_test_variants_banner_id_fkey";

alter table "public"."ab_test_variants" add constraint "ab_test_variants_coupon_template_id_fkey" FOREIGN KEY (coupon_template_id) REFERENCES public.coupon_templates(id) ON DELETE CASCADE not valid;

alter table "public"."ab_test_variants" validate constraint "ab_test_variants_coupon_template_id_fkey";

alter table "public"."ab_test_variants" add constraint "ab_test_variants_test_id_fkey" FOREIGN KEY (test_id) REFERENCES public.ab_tests(id) ON DELETE CASCADE not valid;

alter table "public"."ab_test_variants" validate constraint "ab_test_variants_test_id_fkey";

alter table "public"."ab_tests" add constraint "ab_tests_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."ab_tests" validate constraint "ab_tests_brand_id_fkey";

alter table "public"."ab_tests" add constraint "ab_tests_target_segment_id_fkey" FOREIGN KEY (target_segment_id) REFERENCES public.customer_segments(id) ON DELETE SET NULL not valid;

alter table "public"."ab_tests" validate constraint "ab_tests_target_segment_id_fkey";

alter table "public"."app_builds" add constraint "app_builds_app_config_id_fkey" FOREIGN KEY (app_config_id) REFERENCES public.app_configs(id) ON DELETE CASCADE not valid;

alter table "public"."app_builds" validate constraint "app_builds_app_config_id_fkey";

alter table "public"."app_builds" add constraint "app_builds_completed_has_download" CHECK (((status <> 'completed'::public.build_status) OR (download_url IS NOT NULL))) not valid;

alter table "public"."app_builds" validate constraint "app_builds_completed_has_download";

alter table "public"."app_configs" add constraint "app_configs_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."app_configs" validate constraint "app_configs_brand_id_fkey";

alter table "public"."banner_interactions" add constraint "banner_interactions_banner_id_fkey" FOREIGN KEY (banner_id) REFERENCES public.promotion_banners(id) ON DELETE CASCADE not valid;

alter table "public"."banner_interactions" validate constraint "banner_interactions_banner_id_fkey";

alter table "public"."banner_interactions" add constraint "banner_interactions_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL not valid;

alter table "public"."banner_interactions" validate constraint "banner_interactions_customer_id_fkey";

alter table "public"."coupon_templates" add constraint "coupon_templates_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."coupon_templates" validate constraint "coupon_templates_brand_id_fkey";

alter table "public"."coupons" add constraint "coupons_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."coupons" validate constraint "coupons_brand_id_fkey";

alter table "public"."coupons" add constraint "coupons_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE not valid;

alter table "public"."coupons" validate constraint "coupons_customer_id_fkey";

alter table "public"."coupons" add constraint "coupons_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) not valid;

alter table "public"."coupons" validate constraint "coupons_order_id_fkey";

alter table "public"."customer_segments" add constraint "customer_segments_auto_has_conditions" CHECK (((type = 'manual'::public.segment_type) OR ((type = 'auto'::public.segment_type) AND (conditions IS NOT NULL)))) not valid;

alter table "public"."customer_segments" validate constraint "customer_segments_auto_has_conditions";

alter table "public"."customer_segments" add constraint "customer_segments_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."customer_segments" validate constraint "customer_segments_brand_id_fkey";

alter table "public"."customers" add constraint "customers_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE NOT VALID not valid;

alter table "public"."customers" validate constraint "customers_brand_id_fkey";

alter table "public"."inventory" add constraint "inventory_item_id_fkey" FOREIGN KEY (item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE not valid;

alter table "public"."inventory" validate constraint "inventory_item_id_fkey";

alter table "public"."inventory" add constraint "inventory_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."inventory" validate constraint "inventory_store_id_fkey";

alter table "public"."loyalty_transactions" add constraint "loyalty_transactions_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."loyalty_transactions" validate constraint "loyalty_transactions_brand_id_fkey";

alter table "public"."loyalty_transactions" add constraint "loyalty_transactions_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE not valid;

alter table "public"."loyalty_transactions" validate constraint "loyalty_transactions_customer_id_fkey";

alter table "public"."loyalty_transactions" add constraint "loyalty_transactions_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL not valid;

alter table "public"."loyalty_transactions" validate constraint "loyalty_transactions_order_id_fkey";

alter table "public"."menu_categories" add constraint "menu_categories_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."menu_categories" validate constraint "menu_categories_brand_id_fkey";

alter table "public"."menu_categories" add constraint "menu_categories_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES public.menu_categories(id) ON DELETE CASCADE not valid;

alter table "public"."menu_categories" validate constraint "menu_categories_parent_id_fkey";

alter table "public"."menu_categories" add constraint "menu_categories_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."menu_categories" validate constraint "menu_categories_store_id_fkey";

alter table "public"."menu_items" add constraint "menu_items_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."menu_items" validate constraint "menu_items_brand_id_fkey";

alter table "public"."menu_items" add constraint "menu_items_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public.menu_categories(id) ON DELETE SET NULL not valid;

alter table "public"."menu_items" validate constraint "menu_items_category_id_fkey";

alter table "public"."menu_items" add constraint "menu_items_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."menu_items" validate constraint "menu_items_store_id_fkey";

alter table "public"."menu_modifiers" add constraint "menu_modifiers_item_id_fkey" FOREIGN KEY (item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE not valid;

alter table "public"."menu_modifiers" validate constraint "menu_modifiers_item_id_fkey";

alter table "public"."menu_schedules" add constraint "menu_schedules_menu_item_id_fkey" FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE not valid;

alter table "public"."menu_schedules" validate constraint "menu_schedules_menu_item_id_fkey";

alter table "public"."notification_logs" add constraint "notification_logs_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE not valid;

alter table "public"."notification_logs" validate constraint "notification_logs_customer_id_fkey";

alter table "public"."notification_logs" add constraint "notification_logs_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL not valid;

alter table "public"."notification_logs" validate constraint "notification_logs_order_id_fkey";

alter table "public"."notification_templates" add constraint "notification_templates_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."notification_templates" validate constraint "notification_templates_brand_id_fkey";

alter table "public"."notifications" add constraint "notifications_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."notifications" validate constraint "notifications_brand_id_fkey";

alter table "public"."notifications" add constraint "notifications_individual_target_has_customers" CHECK (((target <> 'individual'::public.notification_target) OR (customer_ids IS NOT NULL))) not valid;

alter table "public"."notifications" validate constraint "notifications_individual_target_has_customers";

alter table "public"."notifications" add constraint "notifications_segment_id_fkey" FOREIGN KEY (segment_id) REFERENCES public.customer_segments(id) ON DELETE SET NULL not valid;

alter table "public"."notifications" validate constraint "notifications_segment_id_fkey";

alter table "public"."notifications" add constraint "notifications_segment_target_has_segment" CHECK (((target <> 'segment'::public.notification_target) OR (segment_id IS NOT NULL))) not valid;

alter table "public"."notifications" validate constraint "notifications_segment_target_has_segment";

alter table "public"."order_status_history" add constraint "order_status_history_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."order_status_history" validate constraint "order_status_history_order_id_fkey";

alter table "public"."orders" add constraint "orders_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."orders" validate constraint "orders_brand_id_fkey";

alter table "public"."orders" add constraint "orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE not valid;

alter table "public"."orders" validate constraint "orders_customer_id_fkey";

alter table "public"."orders" add constraint "orders_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."orders" validate constraint "orders_store_id_fkey";

alter table "public"."pickup_reservations" add constraint "pickup_reservations_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE not valid;

alter table "public"."pickup_reservations" validate constraint "pickup_reservations_customer_id_fkey";

alter table "public"."pickup_reservations" add constraint "pickup_reservations_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."pickup_reservations" validate constraint "pickup_reservations_store_id_fkey";

alter table "public"."pickup_slots" add constraint "pickup_slots_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."pickup_slots" validate constraint "pickup_slots_store_id_fkey";

alter table "public"."promotion_banners" add constraint "promotion_banners_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."promotion_banners" validate constraint "promotion_banners_brand_id_fkey";

alter table "public"."promotions" add constraint "promotions_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."promotions" validate constraint "promotions_brand_id_fkey";

alter table "public"."push_tokens" add constraint "push_tokens_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE not valid;

alter table "public"."push_tokens" validate constraint "push_tokens_customer_id_fkey";

alter table "public"."recommended_menu_configs" add constraint "recommended_menu_configs_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."recommended_menu_configs" validate constraint "recommended_menu_configs_brand_id_fkey";

alter table "public"."refunds" add constraint "refunds_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."refunds" validate constraint "refunds_order_id_fkey";

alter table "public"."staff" add constraint "staff_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."staff" validate constraint "staff_store_id_fkey";

alter table "public"."stamp_cards" add constraint "stamp_cards_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."stamp_cards" validate constraint "stamp_cards_brand_id_fkey";

alter table "public"."stamp_cards" add constraint "stamp_cards_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE not valid;

alter table "public"."stamp_cards" validate constraint "stamp_cards_customer_id_fkey";

alter table "public"."stores" add constraint "stores_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."stores" validate constraint "stores_brand_id_fkey";

alter table "public"."subscriptions" add constraint "subscriptions_brand_id_fkey" FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE not valid;

alter table "public"."subscriptions" validate constraint "subscriptions_brand_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.auto_cancel_payment_issue_orders()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
  cancelled_count INTEGER;
BEGIN
  UPDATE orders
  SET
    status = 'cancelled',
    updated_at = NOW()
  WHERE
    status = 'payment_issue' AND
    updated_at < NOW() - INTERVAL '10 minutes';

  GET DIAGNOSTICS cancelled_count = ROW_COUNT;

  -- Log status changes
  INSERT INTO order_status_history (order_id, from_status, to_status, reason)
  SELECT id, 'payment_issue', 'cancelled', 'Auto-cancelled: payment not resolved within 10 minutes'
  FROM orders
  WHERE status = 'cancelled' AND updated_at = NOW();

  RETURN cancelled_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.auto_disable_on_zero_inventory()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.auto_disable_on_zero = TRUE
       AND NEW.inventory_tracked = TRUE
       AND NEW.inventory_quantity IS NOT NULL
       AND NEW.inventory_quantity <= 0
       AND NEW.available = TRUE THEN

        NEW.available := FALSE;
    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.auto_disable_out_of_stock_items()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- If quantity drops to 0, disable the item
  IF NEW.quantity = 0 AND OLD.quantity > 0 THEN
    UPDATE menu_items
    SET available = FALSE
    WHERE id = NEW.item_id AND inventory_tracked = TRUE;
  END IF;

  -- If quantity increases from 0, re-enable the item
  IF NEW.quantity > 0 AND OLD.quantity = 0 THEN
    UPDATE menu_items
    SET available = TRUE
    WHERE id = NEW.item_id AND inventory_tracked = TRUE;
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.award_loyalty_points()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_brand_id UUID;
    v_loyalty_config JSONB;
    v_points_rate DECIMAL;
    v_points_earned INTEGER;
    v_current_balance INTEGER;
BEGIN
    -- Only trigger when order status changes to 'completed'
    IF (TG_OP = 'UPDATE' AND NEW.status = 'completed' AND OLD.status != 'completed') THEN

        -- Get brand_id from store
        SELECT brand_id INTO v_brand_id
        FROM stores
        WHERE id = NEW.store_id;

        -- Get loyalty configuration for this brand
        SELECT feature_toggles->'loyalty' INTO v_loyalty_config
        FROM app_configs
        WHERE brand_id = v_brand_id;

        -- Check if loyalty is enabled
        IF v_loyalty_config IS NOT NULL AND (v_loyalty_config->>'enabled')::boolean = true THEN

            -- Calculate points: order_total * points_earn_rate / 100
            v_points_rate := (v_loyalty_config->>'points_earn_rate')::decimal;
            v_points_earned := FLOOR(NEW.total_amount * v_points_rate / 100);

            -- Get customer's current balance (0 if no transactions yet)
            SELECT COALESCE(MAX(balance), 0) INTO v_current_balance
            FROM loyalty_transactions
            WHERE customer_id = NEW.customer_id;

            -- Insert loyalty transaction
            INSERT INTO loyalty_transactions (
                customer_id,
                order_id,
                points_earned,
                points_spent,
                balance
            ) VALUES (
                NEW.customer_id,
                NEW.id,
                v_points_earned,
                0,
                v_current_balance + v_points_earned
            );

            -- Update customer's loyalty_points
            UPDATE customers
            SET loyalty_points = v_current_balance + v_points_earned,
                updated_at = NOW()
            WHERE id = NEW.customer_id;

        END IF;

    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.award_stamps()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_brand_id UUID;
    v_loyalty_config JSONB;
    v_stamps_per_order INTEGER;
    v_stamps_for_reward INTEGER;
    v_current_stamps INTEGER;
    v_reward_coupon_type TEXT;
    v_reward_coupon_value DECIMAL;
    v_coupon_code TEXT;
BEGIN
    -- Only trigger when order status changes to 'completed'
    IF (TG_OP = 'UPDATE' AND NEW.status = 'completed' AND OLD.status != 'completed') THEN

        -- Get brand_id from store
        SELECT brand_id INTO v_brand_id
        FROM stores
        WHERE id = NEW.store_id;

        -- Get loyalty configuration for this brand
        SELECT feature_toggles->'loyalty' INTO v_loyalty_config
        FROM app_configs
        WHERE brand_id = v_brand_id;

        -- Check if stamps are enabled
        IF v_loyalty_config IS NOT NULL
           AND (v_loyalty_config->>'enabled')::boolean = true
           AND (v_loyalty_config->>'stamps_enabled')::boolean = true THEN

            v_stamps_per_order := (v_loyalty_config->>'stamps_per_order')::integer;
            v_stamps_for_reward := (v_loyalty_config->>'stamps_for_reward')::integer;

            -- Get or create stamp card
            INSERT INTO stamp_cards (customer_id, brand_id, stamps_earned, stamps_used, current_stamps)
            VALUES (NEW.customer_id, v_brand_id, 0, 0, 0)
            ON CONFLICT (customer_id, brand_id) DO NOTHING;

            -- Update stamp card
            UPDATE stamp_cards
            SET stamps_earned = stamps_earned + v_stamps_per_order,
                current_stamps = current_stamps + v_stamps_per_order,
                updated_at = NOW()
            WHERE customer_id = NEW.customer_id AND brand_id = v_brand_id
            RETURNING current_stamps INTO v_current_stamps;

            -- Check if customer earned a reward
            IF v_current_stamps >= v_stamps_for_reward THEN

                v_reward_coupon_type := v_loyalty_config->>'reward_coupon_type';
                v_reward_coupon_value := (v_loyalty_config->>'reward_coupon_value')::decimal;

                -- Generate unique coupon code
                v_coupon_code := 'STAMP-' || substring(gen_random_uuid()::text, 1, 8);

                -- Create reward coupon
                INSERT INTO coupons (
                    brand_id,
                    customer_id,
                    code,
                    type,
                    value,
                    min_order_value,
                    expires_at
                ) VALUES (
                    v_brand_id,
                    NEW.customer_id,
                    v_coupon_code,
                    v_reward_coupon_type::coupon_type,
                    v_reward_coupon_value,
                    NULL,
                    NOW() + INTERVAL '90 days'
                );

                -- Deduct used stamps
                UPDATE stamp_cards
                SET stamps_used = stamps_used + v_stamps_for_reward,
                    current_stamps = current_stamps - v_stamps_for_reward,
                    updated_at = NOW()
                WHERE customer_id = NEW.customer_id AND brand_id = v_brand_id;

            END IF;

        END IF;

    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cascade_master_menu_updates()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- When a brand-level menu item's price changes, update store-level overrides
  IF NEW.store_id IS NULL AND NEW.price != OLD.price THEN
    UPDATE menu_items
    SET price = NEW.price
    WHERE brand_id = NEW.brand_id
      AND store_id IS NOT NULL
      AND id = NEW.id;
  END IF;

  -- When a brand-level item's availability changes
  IF NEW.store_id IS NULL AND NEW.available != OLD.available THEN
    UPDATE menu_items
    SET available = NEW.available
    WHERE brand_id = NEW.brand_id
      AND store_id IS NOT NULL
      AND id = NEW.id;
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_pickup_slot_capacity(p_store_id uuid, p_pickup_time timestamp with time zone)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
  slot_capacity INTEGER;
  current_count INTEGER;
  day_of_week INTEGER;
BEGIN
  -- Get day of week from pickup time (0 = Sunday)
  day_of_week := EXTRACT(DOW FROM p_pickup_time);

  -- Get capacity for this day
  SELECT capacity_per_slot INTO slot_capacity
  FROM pickup_slots
  WHERE store_id = p_store_id AND day_of_week = day_of_week;

  -- If no slot configuration found, default to allowing
  IF slot_capacity IS NULL THEN
    RETURN TRUE;
  END IF;

  -- Count existing orders + reservations for this slot
  SELECT COUNT(*) INTO current_count
  FROM (
    SELECT 1 FROM orders
    WHERE store_id = p_store_id
      AND pickup_window_start = p_pickup_time
      AND status NOT IN ('cancelled', 'completed')
    UNION ALL
    SELECT 1 FROM pickup_reservations
    WHERE store_id = p_store_id
      AND pickup_time = p_pickup_time
      AND expires_at > NOW()
  ) AS combined;

  -- Return TRUE if capacity available
  RETURN current_count < slot_capacity;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.customer_matches_segment(p_customer_id uuid, p_segment_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_segment RECORD;
    v_condition JSONB;
    v_field TEXT;
    v_operator TEXT;
    v_value TEXT;
    v_customer_value NUMERIC;
    v_matches BOOLEAN := TRUE;
BEGIN
    -- Get segment
    SELECT * INTO v_segment
    FROM customer_segments
    WHERE id = p_segment_id;

    IF v_segment IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Manual segment: check if customer is in list
    IF v_segment.type = 'manual' THEN
        RETURN p_customer_id = ANY(v_segment.customer_ids);
    END IF;

    -- Auto segment: evaluate conditions
    FOR v_condition IN SELECT * FROM jsonb_array_elements(v_segment.conditions)
    LOOP
        v_field := v_condition->>'field';
        v_operator := v_condition->>'operator';
        v_value := v_condition->>'value';

        -- Get customer value for field
        IF v_field = 'order_count' THEN
            SELECT COUNT(*) INTO v_customer_value
            FROM orders
            WHERE customer_id = p_customer_id;
        ELSIF v_field = 'total_spent' THEN
            SELECT COALESCE(SUM(total_amount), 0) INTO v_customer_value
            FROM orders
            WHERE customer_id = p_customer_id AND status = 'completed';
        ELSIF v_field = 'last_order_days_ago' THEN
            SELECT COALESCE(EXTRACT(DAY FROM NOW() - MAX(created_at)), 999) INTO v_customer_value
            FROM orders
            WHERE customer_id = p_customer_id;
        ELSE
            -- Unknown field
            RETURN FALSE;
        END IF;

        -- Evaluate condition
        IF v_operator = '>' THEN
            v_matches := v_customer_value > v_value::NUMERIC;
        ELSIF v_operator = '<' THEN
            v_matches := v_customer_value < v_value::NUMERIC;
        ELSIF v_operator = '=' THEN
            v_matches := v_customer_value = v_value::NUMERIC;
        ELSIF v_operator = '>=' THEN
            v_matches := v_customer_value >= v_value::NUMERIC;
        ELSIF v_operator = '<=' THEN
            v_matches := v_customer_value <= v_value::NUMERIC;
        ELSE
            -- Unknown operator
            RETURN FALSE;
        END IF;

        -- If any condition fails, return false
        IF NOT v_matches THEN
            RETURN FALSE;
        END IF;
    END LOOP;

    RETURN TRUE;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.decrease_inventory_on_order()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  item JSONB;
  item_id UUID;
  item_quantity INTEGER;
BEGIN
  -- Only decrease inventory when order moves to 'waiting' status
  IF NEW.status = 'waiting' AND OLD.status = 'pending' THEN
    -- Loop through order items
    FOR item IN SELECT * FROM jsonb_array_elements(NEW.items)
    LOOP
      item_id := (item->>'item_id')::UUID;
      item_quantity := (item->>'quantity')::INTEGER;

      -- Decrease inventory for items with inventory tracking
      UPDATE inventory
      SET quantity = quantity - item_quantity,
          updated_at = NOW()
      WHERE store_id = NEW.store_id
        AND item_id = item_id
        AND EXISTS (
          SELECT 1 FROM menu_items
          WHERE id = item_id AND inventory_tracked = TRUE
        );
    END LOOP;
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_expired_reservations()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
  deleted_count INTEGER;
BEGIN
  DELETE FROM pickup_reservations
  WHERE expires_at < NOW();

  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  RETURN deleted_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_app_config(config_id uuid)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'id', ac.id,
        'brand_id', ac.brand_id,
        'app_name', ac.app_name,
        'logo_url', ac.logo_url,
        'primary_color', ac.primary_color,
        'feature_toggles', ac.feature_toggles,
        'build_version', ac.build_version
    )
    INTO result
    FROM app_configs ac
    WHERE ac.id = config_id;

    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_build_status(p_app_config_id uuid)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', ab.id,
            'platform', ab.platform,
            'status', ab.status,
            'build_number', ab.build_number,
            'download_url', ab.download_url,
            'error_message', ab.error_message,
            'started_at', ab.started_at,
            'completed_at', ab.completed_at
        )
        ORDER BY ab.started_at DESC
    )
    INTO result
    FROM app_builds ab
    WHERE ab.app_config_id = p_app_config_id;

    RETURN COALESCE(result, '[]'::json);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.increment_coupon_usage()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.used_at IS NOT NULL AND OLD.used_at IS NULL THEN
        UPDATE coupons
        SET usage_count = usage_count + 1
        WHERE id = NEW.id;
    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.is_brand_admin()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
  SELECT public.user_role() IN ('brand_admin', 'super_admin');
$function$
;

CREATE OR REPLACE FUNCTION public.is_super_admin()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
  SELECT public.user_role() = 'super_admin';
$function$
;

CREATE OR REPLACE FUNCTION public.log_order_status_change()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- Only log if status actually changed
  IF NEW.status != OLD.status THEN
    INSERT INTO order_status_history (order_id, from_status, to_status)
    VALUES (NEW.id, OLD.status, NEW.status);
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_order_total_amount()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.total_amount := NEW.total;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.trigger_app_build(p_app_config_id uuid, p_github_token text DEFAULT NULL::text)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_brand_id UUID;
    v_app_name TEXT;
    result JSON;
BEGIN
    -- Get brand_id from app_config
    SELECT brand_id, app_name
    INTO v_brand_id, v_app_name
    FROM app_configs
    WHERE id = p_app_config_id;

    IF v_brand_id IS NULL THEN
        RAISE EXCEPTION 'App configuration not found';
    END IF;

    -- Return payload for GitHub repository dispatch
    result := json_build_object(
        'event_type', 'build_brand_app',
        'client_payload', json_build_object(
            'brand_id', v_brand_id,
            'app_config_id', p_app_config_id,
            'app_name', v_app_name
        )
    );

    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_banner_stats()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.action = 'view' THEN
        UPDATE promotion_banners
        SET view_count = view_count + 1
        WHERE id = NEW.banner_id;
    ELSIF NEW.action = 'click' THEN
        UPDATE promotion_banners
        SET click_count = click_count + 1
        WHERE id = NEW.banner_id;
    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.user_brand_id()
 RETURNS uuid
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
  SELECT COALESCE(
    (auth.jwt() -> 'app_metadata' ->> 'brand_id')::UUID,
    NULL
  );
$function$
;

CREATE OR REPLACE FUNCTION public.user_role()
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
  SELECT COALESCE(
    auth.jwt() -> 'app_metadata' ->> 'role',
    'customer'
  )::TEXT;
$function$
;

CREATE OR REPLACE FUNCTION public.user_store_id()
 RETURNS uuid
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
  SELECT COALESCE(
    (auth.jwt() -> 'app_metadata' ->> 'store_id')::UUID,
    NULL
  );
$function$
;

CREATE OR REPLACE FUNCTION public.validate_pickup_reservation()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF NOT check_pickup_slot_capacity(NEW.store_id, NEW.pickup_time) THEN
    RAISE EXCEPTION 'Pickup slot is full. Please select a different time.';
  END IF;

  -- Set expiration to 2 minutes from now
  NEW.expires_at := NOW() + INTERVAL '2 minutes';

  RETURN NEW;
END;
$function$
;

create policy "Brand admins can view conversions"
on "public"."ab_test_conversions"
as permissive
for select
to public
using ((test_id IN ( SELECT ab_tests.id
   FROM public.ab_tests
  WHERE (ab_tests.brand_id = public.user_brand_id()))));


create policy "Anyone can view exposures for brand tests"
on "public"."ab_test_exposures"
as permissive
for select
to public
using ((test_id IN ( SELECT ab_tests.id
   FROM public.ab_tests
  WHERE (ab_tests.brand_id = public.user_brand_id()))));


create policy "Brand admins can manage variants"
on "public"."ab_test_variants"
as permissive
for all
to public
using ((test_id IN ( SELECT ab_tests.id
   FROM public.ab_tests
  WHERE (ab_tests.brand_id = public.user_brand_id()))));


create policy "Brand admins can create ab_tests"
on "public"."ab_tests"
as permissive
for insert
to public
with check ((brand_id = public.user_brand_id()));


create policy "Brand admins can delete own ab_tests"
on "public"."ab_tests"
as permissive
for delete
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can update own ab_tests"
on "public"."ab_tests"
as permissive
for update
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can view own ab_tests"
on "public"."ab_tests"
as permissive
for select
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can view their app builds"
on "public"."app_builds"
as permissive
for select
to authenticated
using ((app_config_id IN ( SELECT app_configs.id
   FROM public.app_configs
  WHERE (app_configs.brand_id = public.user_brand_id()))));


create policy "Brand admins can manage their app config"
on "public"."app_configs"
as permissive
for all
to authenticated
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can view banner interactions"
on "public"."banner_interactions"
as permissive
for select
to public
using ((banner_id IN ( SELECT promotion_banners.id
   FROM public.promotion_banners
  WHERE (promotion_banners.brand_id = public.user_brand_id()))));


create policy "Brand admins can view their brand"
on "public"."brands"
as permissive
for select
to authenticated
using ((id = public.user_brand_id()));


create policy "Only super admins can create brands"
on "public"."brands"
as permissive
for insert
to authenticated
with check (public.is_super_admin());


create policy "Super admins can update all brands"
on "public"."brands"
as permissive
for update
to authenticated
using (public.is_super_admin());


create policy "Super admins can view all brands"
on "public"."brands"
as permissive
for select
to authenticated
using (public.is_super_admin());


create policy "Brand admins can manage coupon templates"
on "public"."coupon_templates"
as permissive
for all
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can create coupons"
on "public"."coupons"
as permissive
for insert
to public
with check ((brand_id = public.user_brand_id()));


create policy "Brand admins can delete coupons"
on "public"."coupons"
as permissive
for delete
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can manage coupons"
on "public"."coupons"
as permissive
for all
to authenticated
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can update coupons"
on "public"."coupons"
as permissive
for update
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can view coupons"
on "public"."coupons"
as permissive
for select
to public
using ((brand_id = public.user_brand_id()));


create policy "Customers can mark coupons as used"
on "public"."coupons"
as permissive
for update
to public
using ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))))
with check ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Customers can view own coupons"
on "public"."coupons"
as permissive
for select
to public
using ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Customers can view their own coupons"
on "public"."coupons"
as permissive
for select
to authenticated
using (((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))) OR (customer_id IS NULL)));


create policy "Brand admins can manage customer segments"
on "public"."customer_segments"
as permissive
for all
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can view their brand's customers"
on "public"."customers"
as permissive
for select
to authenticated
using (((brand_id = public.user_brand_id()) AND public.is_brand_admin()));


create policy "Customers can update their own profile"
on "public"."customers"
as permissive
for update
to authenticated
using (((user_id = auth.uid()) AND ((brand_id = public.user_brand_id()) OR (public.user_brand_id() IS NULL))));


create policy "Customers can view their own profile"
on "public"."customers"
as permissive
for select
to authenticated
using (((user_id = auth.uid()) AND ((brand_id = public.user_brand_id()) OR (public.user_brand_id() IS NULL))));


create policy "Super admins can view all customers"
on "public"."customers"
as permissive
for select
to authenticated
using (public.is_super_admin());


create policy "Staff can update their store's inventory"
on "public"."inventory"
as permissive
for all
to authenticated
using (((store_id = public.user_store_id()) OR public.is_brand_admin()));


create policy "Staff can view their store's inventory"
on "public"."inventory"
as permissive
for select
to authenticated
using (((store_id = public.user_store_id()) OR public.is_brand_admin()));


create policy "Customers can view their own loyalty transactions"
on "public"."loyalty_transactions"
as permissive
for select
to authenticated
using ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Brand admins can delete menu categories"
on "public"."menu_categories"
as permissive
for delete
to authenticated
using (((brand_id = public.user_brand_id()) AND public.is_brand_admin()));


create policy "Brand admins can insert menu categories"
on "public"."menu_categories"
as permissive
for insert
to authenticated
with check (((brand_id = public.user_brand_id()) AND public.is_brand_admin()));


create policy "Brand admins can update menu categories"
on "public"."menu_categories"
as permissive
for update
to authenticated
using (((brand_id = public.user_brand_id()) AND public.is_brand_admin()));


create policy "Brand admins can view their menu categories"
on "public"."menu_categories"
as permissive
for select
to authenticated
using (((brand_id = public.user_brand_id()) AND public.is_brand_admin()));


create policy "Customers can view available menu categories"
on "public"."menu_categories"
as permissive
for select
to authenticated
using (((available = true) AND (public.user_role() <> ALL (ARRAY['brand_admin'::text, 'super_admin'::text]))));


create policy "Brand admins can delete menu items"
on "public"."menu_items"
as permissive
for delete
to authenticated
using (((brand_id = public.user_brand_id()) AND public.is_brand_admin()));


create policy "Brand admins can insert menu items"
on "public"."menu_items"
as permissive
for insert
to authenticated
with check (((brand_id = public.user_brand_id()) AND public.is_brand_admin()));


create policy "Brand admins can update menu items"
on "public"."menu_items"
as permissive
for update
to authenticated
using (((brand_id = public.user_brand_id()) AND public.is_brand_admin()));


create policy "Brand admins can view their menu items"
on "public"."menu_items"
as permissive
for select
to authenticated
using (((brand_id = public.user_brand_id()) AND public.is_brand_admin()));


create policy "Customers can view available menu items"
on "public"."menu_items"
as permissive
for select
to authenticated
using (((available = true) AND (public.user_role() <> ALL (ARRAY['brand_admin'::text, 'super_admin'::text]))));


create policy "Brand admins can delete menu modifiers"
on "public"."menu_modifiers"
as permissive
for delete
to authenticated
using (((item_id IN ( SELECT menu_items.id
   FROM public.menu_items
  WHERE (menu_items.brand_id = public.user_brand_id()))) AND public.is_brand_admin()));


create policy "Brand admins can insert menu modifiers"
on "public"."menu_modifiers"
as permissive
for insert
to authenticated
with check (((item_id IN ( SELECT menu_items.id
   FROM public.menu_items
  WHERE (menu_items.brand_id = public.user_brand_id()))) AND public.is_brand_admin()));


create policy "Brand admins can update menu modifiers"
on "public"."menu_modifiers"
as permissive
for update
to authenticated
using (((item_id IN ( SELECT menu_items.id
   FROM public.menu_items
  WHERE (menu_items.brand_id = public.user_brand_id()))) AND public.is_brand_admin()));


create policy "Brand admins can view their menu modifiers"
on "public"."menu_modifiers"
as permissive
for select
to authenticated
using (((item_id IN ( SELECT menu_items.id
   FROM public.menu_items
  WHERE (menu_items.brand_id = public.user_brand_id()))) AND public.is_brand_admin()));


create policy "Customers can view menu modifiers"
on "public"."menu_modifiers"
as permissive
for select
to authenticated
using (((public.user_role() <> ALL (ARRAY['brand_admin'::text, 'super_admin'::text])) AND (item_id IN ( SELECT menu_items.id
   FROM public.menu_items
  WHERE (menu_items.available = true)))));


create policy "Brand admins can manage menu schedules"
on "public"."menu_schedules"
as permissive
for all
to public
using ((menu_item_id IN ( SELECT menu_items.id
   FROM public.menu_items
  WHERE (menu_items.brand_id = public.user_brand_id()))));


create policy "Store managers can view menu schedules"
on "public"."menu_schedules"
as permissive
for select
to public
using ((menu_item_id IN ( SELECT mi.id
   FROM (public.menu_items mi
     JOIN public.stores s ON ((mi.store_id = s.id)))
  WHERE (s.manager_id = auth.uid()))));


create policy "Customers can view their own notifications"
on "public"."notification_logs"
as permissive
for select
to authenticated
using ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Brand admins can manage notification templates"
on "public"."notification_templates"
as permissive
for all
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can manage notifications"
on "public"."notifications"
as permissive
for all
to public
using ((brand_id = public.user_brand_id()));


create policy "Customers can view own notifications"
on "public"."notifications"
as permissive
for select
to public
using (((target = 'all'::public.notification_target) OR ((target = 'individual'::public.notification_target) AND (auth.uid() = ANY (customer_ids))) OR ((target = 'segment'::public.notification_target) AND (EXISTS ( SELECT 1
   FROM public.customer_segments cs
  WHERE ((cs.id = notifications.segment_id) AND ((auth.uid() = ANY (cs.customer_ids)) OR ((cs.type = 'auto'::public.segment_type) AND (cs.brand_id IN ( SELECT customers.brand_id
           FROM public.customers
          WHERE (customers.user_id = auth.uid())))))))))));


create policy "Customers can view their order history"
on "public"."order_status_history"
as permissive
for select
to authenticated
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.customer_id IN ( SELECT customers.id
           FROM public.customers
          WHERE (customers.user_id = auth.uid()))))));


create policy "Staff can manage order history for their store"
on "public"."order_status_history"
as permissive
for all
to authenticated
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.store_id = public.user_store_id()) OR (orders.store_id IN ( SELECT stores.id
           FROM public.stores
          WHERE (stores.brand_id = public.user_brand_id())))))));


create policy "Customers can create orders"
on "public"."orders"
as permissive
for insert
to authenticated
with check ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Customers can view their own orders"
on "public"."orders"
as permissive
for select
to authenticated
using ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Staff can update their store's orders"
on "public"."orders"
as permissive
for update
to authenticated
using (((store_id = public.user_store_id()) OR public.is_brand_admin()));


create policy "Staff can view their store's orders"
on "public"."orders"
as permissive
for select
to authenticated
using (((store_id = public.user_store_id()) OR public.is_brand_admin()));


create policy "Customers can create reservations"
on "public"."pickup_reservations"
as permissive
for insert
to authenticated
with check ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Customers can view their own reservations"
on "public"."pickup_reservations"
as permissive
for select
to authenticated
using ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Staff can manage their store's pickup slots"
on "public"."pickup_slots"
as permissive
for all
to authenticated
using (((store_id = public.user_store_id()) OR public.is_brand_admin()));


create policy "Brand admins can create promotion banners"
on "public"."promotion_banners"
as permissive
for insert
to public
with check ((brand_id = public.user_brand_id()));


create policy "Brand admins can delete their promotion banners"
on "public"."promotion_banners"
as permissive
for delete
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can update their promotion banners"
on "public"."promotion_banners"
as permissive
for update
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can view their promotion banners"
on "public"."promotion_banners"
as permissive
for select
to public
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can manage promotions"
on "public"."promotions"
as permissive
for all
to authenticated
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can view customer push tokens"
on "public"."push_tokens"
as permissive
for select
to public
using ((customer_id IN ( SELECT c.id
   FROM public.customers c
  WHERE (c.brand_id = public.user_brand_id()))));


create policy "Customers can delete own push tokens"
on "public"."push_tokens"
as permissive
for delete
to public
using ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Customers can insert own push tokens"
on "public"."push_tokens"
as permissive
for insert
to public
with check ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Customers can update own push tokens"
on "public"."push_tokens"
as permissive
for update
to public
using ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Customers can view own push tokens"
on "public"."push_tokens"
as permissive
for select
to public
using ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.user_id = auth.uid()))));


create policy "Brand admins can manage recommended menu configs"
on "public"."recommended_menu_configs"
as permissive
for all
to public
using ((brand_id = public.user_brand_id()));


create policy "Customers can view their refunds"
on "public"."refunds"
as permissive
for select
to authenticated
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.customer_id IN ( SELECT customers.id
           FROM public.customers
          WHERE (customers.user_id = auth.uid()))))));


create policy "Staff can manage refunds for their store"
on "public"."refunds"
as permissive
for all
to authenticated
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.store_id = public.user_store_id()) OR (orders.store_id IN ( SELECT stores.id
           FROM public.stores
          WHERE (stores.brand_id = public.user_brand_id())))))));


create policy "Brand admins can manage staff"
on "public"."staff"
as permissive
for all
to authenticated
using ((store_id IN ( SELECT stores.id
   FROM public.stores
  WHERE (stores.brand_id = public.user_brand_id()))));


create policy "Staff can view their store's staff"
on "public"."staff"
as permissive
for select
to authenticated
using (((store_id = public.user_store_id()) OR public.is_brand_admin()));


create policy "Anon can view active stores"
on "public"."stores"
as permissive
for select
to anon
using (((status = 'active'::public.store_status) AND (accepting_orders = true)));


create policy "Brand admins can create stores"
on "public"."stores"
as permissive
for insert
to authenticated
with check ((brand_id = public.user_brand_id()));


create policy "Brand admins can update their stores"
on "public"."stores"
as permissive
for update
to authenticated
using ((brand_id = public.user_brand_id()));


create policy "Brand admins can view their stores"
on "public"."stores"
as permissive
for select
to authenticated
using ((brand_id = public.user_brand_id()));


create policy "Customers can view active stores"
on "public"."stores"
as permissive
for select
to authenticated
using (((status = 'active'::public.store_status) AND (accepting_orders = true)));


create policy "Staff can view their store"
on "public"."stores"
as permissive
for select
to authenticated
using ((id = public.user_store_id()));


create policy "Super admins can view all stores"
on "public"."stores"
as permissive
for select
to authenticated
using (public.is_super_admin());


create policy "Brand admins can view their subscription"
on "public"."subscriptions"
as permissive
for select
to authenticated
using ((brand_id = public.user_brand_id()));


create policy "Only super admins can modify subscriptions"
on "public"."subscriptions"
as permissive
for all
to authenticated
using (public.is_super_admin());


create policy "Super admins can view all subscriptions"
on "public"."subscriptions"
as permissive
for select
to authenticated
using (public.is_super_admin());


CREATE TRIGGER ab_tests_updated_at BEFORE UPDATE ON public.ab_tests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_app_configs_updated_at BEFORE UPDATE ON public.app_configs FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_update_banner_stats AFTER INSERT ON public.banner_interactions FOR EACH ROW EXECUTE FUNCTION public.update_banner_stats();

CREATE TRIGGER update_brands_updated_at BEFORE UPDATE ON public.brands FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_increment_coupon_usage AFTER UPDATE ON public.coupons FOR EACH ROW EXECUTE FUNCTION public.increment_coupon_usage();

CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_auto_disable_out_of_stock AFTER UPDATE ON public.inventory FOR EACH ROW EXECUTE FUNCTION public.auto_disable_out_of_stock_items();

CREATE TRIGGER update_menu_categories_updated_at BEFORE UPDATE ON public.menu_categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_auto_disable_on_zero_inventory BEFORE UPDATE ON public.menu_items FOR EACH ROW EXECUTE FUNCTION public.auto_disable_on_zero_inventory();

CREATE TRIGGER trigger_cascade_master_menu AFTER UPDATE ON public.menu_items FOR EACH ROW WHEN ((new.store_id IS NULL)) EXECUTE FUNCTION public.cascade_master_menu_updates();

CREATE TRIGGER update_menu_items_updated_at BEFORE UPDATE ON public.menu_items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_menu_modifiers_updated_at BEFORE UPDATE ON public.menu_modifiers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_award_loyalty_points AFTER UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.award_loyalty_points();

CREATE TRIGGER trigger_award_stamps AFTER UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.award_stamps();

CREATE TRIGGER trigger_decrease_inventory_on_order AFTER UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.decrease_inventory_on_order();

CREATE TRIGGER trigger_log_order_status_change AFTER UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.log_order_status_change();

CREATE TRIGGER trigger_sync_order_total_amount BEFORE INSERT OR UPDATE OF total ON public.orders FOR EACH ROW EXECUTE FUNCTION public.sync_order_total_amount();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_validate_pickup_reservation BEFORE INSERT ON public.pickup_reservations FOR EACH ROW EXECUTE FUNCTION public.validate_pickup_reservation();

CREATE TRIGGER update_pickup_slots_updated_at BEFORE UPDATE ON public.pickup_slots FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_staff_updated_at BEFORE UPDATE ON public.staff FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_stores_updated_at BEFORE UPDATE ON public.stores FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


