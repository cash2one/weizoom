/**
 * Copyright(c) 2012-2016 weizoom
 */
"use strict";

var debug = require('debug')('m:outline.datas:CommentDialog');
var React = require('react');
var ReactDOM = require('react-dom');
var Action = require('.././rule_order/Action');
var Reactman = require('reactman');



var CardTable = React.createClass({
	handleChoice:function(event) {
		var newState = {};
		var id = event.target.getAttribute('data-cardrule-id')
		newState[id] = true;
		this.setState(newState);
	},
	rowFormatter: function(field, value, data) {
		// if (field === 'models') {
		// 	var models = value;
		// 	var modelEls = models.map(function(model, index) {
		// 		return (
		// 			<div key={"model"+index}>{model.name} - {model.stocks}</div>
		// 		)
		// 	});
		// 	return (
		// 		<div style={{color:'red'}}>{modelEls}</div>
		// 	);
		// } else if (field === 'name') {
		// 	return (
		// 		<a href={'/outline/data/?id='+data.id}>{value}</a>
		// 	)
		// }else if (field === 'action') {
		// 	return (
		// 	<div>
		// 		<a className="btn btn-link btn-xs" onClick={this.onClickDelete} data-product-id={data.id}>删除</a>
		// 		<a className="btn btn-link btn-xs mt5" href={'/outline/data/?id='+data.id}>编辑</a>
		// 		<a className="btn btn-link btn-xs mt5" onClick={this.onClickComment} data-product-id={data.id}>备注</a>
		// 	</div>
		// 	);
		// } else {
		// 	return value;
		// }
		if (field=='action') {
			if (this.state.choiced.id==data.id) {
				return (
				<a className="btn btn-link btn-xs mt5" onClick={this.handleChoice} data-cardrule-id={data.id}>已选择</a>
				)
			} else {
				return (
				<a className="btn btn-link btn-xs mt5" onClick={this.handleChoice} data-cardrule-id={data.id}>选择</a>
				)
			}
			
		} else {
			return value;
		}
	},
	render: function() {
		var cardruletype = this.props.cardruletype;
		var cardrulesResource= {
			resource: 'order.approval_card',
			data: {
				cardruletype:cardruletype,
			}
		};
		return (
			<Reactman.TablePanel>
				<Reactman.TableActionBar></Reactman.TableActionBar>
				<Reactman.Table resource={cardrulesResource} formatter={this.rowFormatter} pagination={true} countPerPage={2} ref="table">
					<Reactman.TableColumn name="卡名称" field="name" width="120px" />
					<Reactman.TableColumn name="面值" field="money" />
					<Reactman.TableColumn name="库存" field="storage_count" width="120px"/>
					<Reactman.TableColumn name="卡类型" field="card_kind" width="80px" />
					<Reactman.TableColumn name="卡号区间" field="card_range" />
					<Reactman.TableColumn name="操作" field="action" width="80px" />
				</Reactman.Table>
			</Reactman.TablePanel>
		);
	}
});

module.exports = CardTable;