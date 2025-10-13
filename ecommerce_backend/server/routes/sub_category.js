const express = require('express');
const SubCategory = require('../models/sub_category');
const subCategoryRouter = express.Router();

subCategoryRouter.post('/api/subcategories', async (req, res) => {
    try {
        const { categoryId, categoryName, image, subCategoryName } = req.body;
        const subcategory = new SubCategory({ categoryId, categoryName, image, subCategoryName });
        const subcategories = await subcategory.save();
        res.status(201).send(subcategories);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

subCategoryRouter.get('/api/subcategories', async (req, res) => {
    try {
        const subcategories = await SubCategory.find();
        res.status(200).send(subcategories);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

subCategoryRouter.get('/api/category/:categoryName/subcategories', async (req, res) => {
    try {
        // extract the categoryName from the request Url using Destructuring..
        const { categoryName } = req.params;
        const subcategories = await SubCategory.find({ categoryName: categoryName });

        // check if any subcategories were found...
        if (!subcategories || subcategories.length == 0) {
            return res.status(404).json({ msg: "subcategories not found" });
        } else {
            res.status(200).json(subcategories);
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = subCategoryRouter;