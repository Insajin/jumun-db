-- Enable Realtime for orders table
-- This allows the Store Dashboard to receive real-time updates when orders are created or updated

-- Add orders table to Realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE orders;

-- Also enable for stores table (for online/offline status updates)
ALTER PUBLICATION supabase_realtime ADD TABLE stores;
