/*
Copyright (c) 2011-2012 Weizoom Inc
*/

/**
 * 对话框
 */
ensureNS('W.dialog.app.group');
W.dialog.app.group.ViewParticipanceDataDialog = W.dialog.Dialog.extend({
	events: _.extend({
	}, W.dialog.Dialog.prototype.events),

	templates: {
		dialogTmpl: '#app-group-viewParticipanceDataDialog-dialog-tmpl'
	},
    getTemplate: function() {
        $('#app-group-viewParticipanceDataDialog-dialog-tmpl').template('groupMember-tmpl');
        return "app-group-viewParticipanceDataDialog-dialog-tmpl";
    },
	onInitialize: function(options) {
		this.table = this.$('[data-ui-role="advanced-table"]').data('view');
	},

	beforeShow: function(options) {
		this.table.reset();
	},

	onShow: function(options) {
		this.activityId = options.activityId;
	},

	afterShow: function(options) {
		// if (this.activityId) {
		// 	W.getApi().call({
		// 		app: 'apps/group',
		// 		resource: 'group_participance',
		// 		scope: this,
		// 		args: {
		// 			id: this.activityId
		// 		},
		// 		success: function(data) {
		// 			this.$dialog.find('.modal-body').text(data);
		// 		},
		// 		error: function(resp) {
		// 		}
		// 	})
		// }
	},

	/**
	 * onGetData: 获取数据
	 */
	onGetData: function(event) {
		return {};
	}
});
