With RelevantProductImages as (
    SELECT 
        ProductId,
        ImageId
    FROM db.ProductImages
    WHERE ImageIndex=0
), RelevantProductImagesWithUrl as (
    SELECT
        ProductId,
        Url
    FROM Temp_ProductImages
    INNER JOIN db.Image as images
    ON RelevantProductImages.ImageId=images.Id
), TitleWithRelevantImageUrl as (
    SELECT
        ProductId,
        Title,
        Url
    FROM RelevantProductImagesWithUrl
    INNER JOIN db.Product as product
    ON RelevantProductImagesWithUrl.ProductId = product.Id
), RelevantProductDescription as (
    SELECT 
        ProductId,
        ISNULL(TranslatedText, OriginalText) as ProductDescriptionText
    FROM db.ProductDescription
    WHERE CountryCode='us'
), TitleImageUrlDescription as (
    SELECT
        Title,
        Url,
        ProductDescriptionText
    FROM TitleWithRelevantImageUrl as Title_plus_url
    INNER JOIN RelevantProductDescription as descriptions
    on Title_plus_url.ProductId=descriptions.ProductId
)
SELECT Title, Url, ProductDescriptionText
FROM TitleImageUrlDescription
