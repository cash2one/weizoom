/*
Copyright (c) 2011-2012 Weizoom Inc
*/

/**
 * 运费模板编辑器
 * @constructor
 */
ensureNS('W.view.mall');
W.view.mall.ProductListView = Backbone.View.extend({
    getModelInfoTemplate: function() {
        $('#mall-product-list-view-model-info-tmpl-src').template('mall-product-list-view-model-info-tmpl');
        return 'mall-product-list-view-model-info-tmpl';
    },

    initialize: function(options) {
        this.$el = $(this.el);
        this.table = this.$('[data-ui-role="advanced-table"]').data('view');
        this.modelInfoTemplate = this.getModelInfoTemplate();
        this.type = options.type || 'onshelf';
    },

    events: {
        'click .xa-onshelf': 'onClickUpdateProductShelveTypeLink',
        'click .xa-offshelf': 'onClickUpdateProductShelveTypeLink',
        'click .xa-recycle': 'onClickUpdateProductShelveTypeLink',
        'click .xa-delete': 'onClickUpdateProductShelveTypeLink',

        'click .xa-batchOnshelf': 'onClickBatchUpdateProductShelveTypeLink',
        'click .xa-batchOffshelf': 'onClickBatchUpdateProductShelveTypeLink',
        'click .xa-batchRecycle': 'onClickBatchUpdateProductShelveTypeLink',
        'click .xa-batchDelete': 'onClickBatchUpdateProductShelveTypeLink',

        'click .xa-modifyStandardModelStocks': 'onClickModifyStandardModelStocksLink',
        'click .xa-modifyCustomModelStocks': 'onClickModifyCustomModelStocksLink',
        'blur .xa-stockInput': 'onConfirmStockInput',
        'keypress .xa-stockInput': 'onPressKeyInStockInput',
        'click .xa-showAllModels': 'onClickShowAllModelsButton',

        'click .xa-selectAll':'onClickSelectAll',
    },

    render: function() {
        this.filterView = new W.view.mall.ProductFilterView({
            el: '.xa-productFilterView'
        });
        this.filterView.on('search', _.bind(this.onSearch, this));
        this.filterView.render();

        this.$('input[type="text"]').eq(0).focus();
    },

    onClickBatchUpdateProductShelveTypeLink: function(event) {
        var $link = $(event.currentTarget);
        var shelveType = null;
        if ($link.hasClass('xa-batchOnshelf')) {
            shelveType = 'onshelf';
        } else if ($link.hasClass('xa-batchOffshelf')) {
            shelveType = 'offshelf'
        } else if ($link.hasClass('xa-batchRecycle')) {
            shelveType = 'recycled'
        } else if ($link.hasClass('xa-batchDelete')) {
            shelveType = 'delete'
        }

        var ids = this.table.getAllSelectedDataIds();
        var _this = this;
        var updateAction = function() {
            W.getApi().call({
                method: 'post',
                app: 'mall',
                api: 'product_shelve_type/batch_update',
                args: {
                    ids: ids,
                    shelve_type: shelveType
                },
                scope: this,
                success: function(data) {
                    for(var i = 0; i < ids.length; ++i) {
                        var id = ids[i];
                        this.$('[data-id="'+id+'"]').remove();
                    }

                    if (this.$('tbody tr').length == 0) {
                        window.location.reload();
                    }
                }
            });
        }

        if (shelveType == 'recycled' || shelveType == 'delete') {
            var msg = shelveType == 'recycled' ? '确认将全部商品放入回收站？' : '确认将全部商品彻底删除？'
            W.requireConfirm({
                $el: $link,
                width:457,
                position:'top',
                isTitle: false,
                msg: msg,
                confirm: updateAction
            });
        } else {
            updateAction();
        }
    },

    onClickUpdateProductShelveTypeLink: function(event) {
        var $link = $(event.currentTarget);
        var shelveType = null;
        if ($link.hasClass('xa-onshelf')) {
            shelveType = 'onshelf';
        } else if ($link.hasClass('xa-offshelf')) {
            shelveType = 'offshelf'
        } else if ($link.hasClass('xa-recycle')) {
            shelveType = 'recycled'
        } else if ($link.hasClass('xa-delete')) {
            shelveType = 'delete'
        }

        var $tr = $link.parents('tr');
        var $trs = $link.parents('table').find('tr');
        var productId = $tr.data('id');
        var _this = this;
        var updateAction = function() {
            W.getApi().call({
                method: 'post',
                app: 'mall',
                api: 'product_shelve_type/update',
                args: {
                    id: productId,
                    shelve_type: shelveType
                },
                scope: this,
                success: function(data) {
                    $tr.remove();

                    if (this.$('tbody tr').length == 0) {
                        window.location.reload();
                    }
                }
            })
        };

        if (shelveType == 'recycled' || shelveType == 'delete') {

            var msg = shelveType == 'recycled' ? '是否放入回收站' : '确认将商品彻底删除'
            W.requireConfirm({
                $el: $link,
                width:420,
                height:55,
                position:'right-middle',
                isTitle: false,
                msg: msg,
                confirm: updateAction
            });
        } else {
            updateAction();
        }
    },

    /**
     * onClickModifyStandardModelStocksLink: 点击修改库存链接的响应函数
     */
    onClickModifyStandardModelStocksLink: function(event) {
        var $link = $(event.currentTarget);
        var $td = $link.parents('td');
        var $stockText = $td.find('.xa-stockText');
        var stockText = $.trim($stockText.text());
        var $stockInput = $td.find('.xa-stockInput');
        $stockText.hide();
        $stockInput.show().focus().val(stockText);
    },

    /**
     * onClickModifyCustomModelStocksLink: 点击修改库存链接的响应函数
     */
    onClickModifyCustomModelStocksLink: function(event) {
        var $target = $(event.currentTarget);
        var $td = $target.parents('td');
        var $tr = $target.parents('tr');
        var id = $tr.data('id');
        var product = this.table.getDataItem(id);
        var models = product.get('models');
        W.dialog.showDialog('W.dialog.mall.UpdateProductModelStocksDialog', {
            models: models,
            success: function(data) {
                var newModelInfos = data;
                W.getApi().call({
                method: 'post',
                app: 'mall',
                api: 'product_model_stocks/update',
                args: W.toFormData({'model_infos': newModelInfos}),
                scope: this,
                success: function(data) {
                    //遍历table中的model，如果该model在newModelInfos中出现，则:
                    //model.stock_type = newModelInfo.stock_type
                    //model.stocks = newModelInfo.stocks
                    var id2newModelInfo = {};
                    for (i = 0; i < newModelInfos.length; ++i) {
                        var newModelInfo = newModelInfos[i];
                        id2newModelInfo[newModelInfo.id] = newModelInfo;
                    }
                    var __sum = 0;  // 库存计数
                    for (i = 0; i < models.length; ++i) {
                        var model = models[i];
                        var newModelInfo = id2newModelInfo[model.id]
                        if (newModelInfo.stock_type == 'unlimit') {
                            model.stock_type = 0;
                            __sum += 1
                        } else {
                            model.stock_type = 1;
                            __sum += parseInt(newModelInfo.stocks);
                        }
                        model.stocks = newModelInfo.stocks;
                    }

                    //将页面上的库存信息替换为最小价格规格的库存信息
                    var sortedModels = _.sortBy(models, function(model) { return model.price; });
                    $td.find('.xa-stockText').text(sortedModels[0].stocks);


                    // 已售罄
                    //
                    $imgbox = $tr.find(".imgBox");
                    $imgbox.find('.xui-i-sellout').remove();

                    if(__sum!=0){
                        $imgbox.find('.xui-i-sellout').remove();
                    }else if(__sum===0){
                        $imgbox.append('<div class="xui-i-sellout">已售罄</div>');
                    }
                },
                error: function(resp) {
                    W.showHint('error', '更新库存失败!')
                }
            })
            }
        });
    },

    /**
     * onClickShowAllModelsButton: 鼠标点击“查看规格”区域的响应函数
     */
    onClickShowAllModelsButton: function(event) {
        var $target = $(event.currentTarget);
        var $tr = $target.parents('tr');
        var id = $tr.data('id');
        var product = this.table.getDataItem(id);
        var models = product.get('models');
        var properties = _.pluck(models[0].property_values, 'propertyName');
        var $node = $.tmpl(this.modelInfoTemplate, {properties: properties, models: models});
        W.popup({
            $el: $target,
            position:'top',
            isTitle: false,
            msg: $node
        });
    },

    /**
     * onConfirmStockInput: 焦点移出库存编辑框时的响应函数
     */
    onConfirmStockInput: function(event) {
        var $td = $(event.currentTarget).parent();
        var $tr = $td.parent();
        var productId = $tr.data('id');
        var $stockText = $td.find('.xa-stockText');
        var $stockInput = $td.find('.xa-stockInput');
        var stockText = $.trim($stockInput.val());
        var $imgbox = $tr.find('.imgBox');  // Image Box
        var productData = this.table.getDataItem(productId);
        if (stockText === '无限') {
            $stockInput.hide();
            $stockText.text(stockText).show();
            $imgbox.find('.xui-i-sellout').remove();
            /* Data Update */
            var data = {'model_infos': [{
                id: productData.get('standard_model').id,
                stock_type: 'unlimit',
                stocks: stockText
            }]};
            W.getApi().call({
                method: 'post',
                app: 'mall',
                api: 'product_model_stocks/update',
                args: W.toFormData(data),
                scope: this,
                success: function(data) {
                    $stockInput.hide();
                    $stockText.text(stockText).show();
                },
                error: function(resp) {
                    W.showHint('error', '更新库存失败!')
                }
            });
        } else if(stockText === "" || parseInt(stockText) != NaN){
            if(stockText===""){stockText = 0;}
            else{stockText = parseInt(stockText);}

            /* Image display status update */
            $imgbox.find('.xui-i-sellout').remove();
            if(stockText){
                $imgbox.find('.xui-i-sellout').remove();
            }else{
                $imgbox.append('<div class="xui-i-sellout">已售罄</div>');
            }
            /* Data Update */
            var data = {'model_infos': [{
                id: productData.get('standard_model').id,
                stock_type: 'limit',
                stocks: stockText
            }]};
            W.getApi().call({
                method: 'post',
                app: 'mall',
                api: 'product_model_stocks/update',
                args: W.toFormData(data),
                scope: this,
                success: function(data) {
                    $stockInput.hide();
                    $stockText.text(stockText).show();
                },
                error: function(resp) {
                    W.showHint('error', '更新库存失败!')
                }
            })
        }
    },

    /**
     * onPressKeyInStockInput: 在库存编辑框中输入回车时的响应函数
     */
    onPressKeyInStockInput: function(event) {
        var keyCode = event.keyCode;
        if(keyCode === 13) {
            this.onConfirmStockInput(event);
        }
    },

    /**
     * onSearch: 响应filter view抛出的search事件
     */
    onSearch: function(data) {
        this.table.reload(data, {
            emptyDataHint: '没有符合条件的商品'
        });
    },
    /**
     * onClickSelectAll: 点击全选选择框时的响应函数
     */
    onClickSelectAll: function(event) {
        var $checkbox = $(event.currentTarget);
        var isChecked = $checkbox.is(':checked');
        this.$('tbody .xa-select').prop('checked', isChecked);
        this.$('.xa-selectAll').prop('checked', isChecked);
        if (isChecked) {
            //this.$('.xa-selectAll').attr('checked', 'checked');
        } else {
            //this.$('.xa-selectAll').removeAttr('checked');
        }
    },

    reset: function() {
        this.$('table').empty();
        this.frozenArgs = {};
    },
});
