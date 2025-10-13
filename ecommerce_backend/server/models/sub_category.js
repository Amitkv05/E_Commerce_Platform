const mongoose = require('mongoose');

const subCategorySchema = mongoose.Schema({
    categoryName: {
        type: String,
        required: true,
    },
    categoryId: {
        type: String,
        required: true
    },
    image: {
        type: String,
        required: true
    },
    subCategoryName: {
        type: String,
        required: true,
    },
});
const subCategory = mongoose.model('SubCategory', subCategorySchema);

module.exports = subCategory;