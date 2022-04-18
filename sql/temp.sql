DROP table cmcard_store_price;
ALTER TABLE cmcardprice DROP COLUMN cmstore;
DROP table cmstore;
ALTER TABLE cmcard ADD COLUMN art_crop_url character varying;
ALTER TABLE cmcard ADD COLUMN normal_url character varying;
ALTER TABLE cmcard ADD COLUMN png_url character varying;