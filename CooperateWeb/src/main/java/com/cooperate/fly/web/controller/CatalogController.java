package com.cooperate.fly.web.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import java.util.LinkedList;
import java.util.List;
import java.util.Objects;

import javax.annotation.Resource;

import com.cooperate.fly.bo.*;
import com.cooperate.fly.mapper.CatalogMapper;
import com.cooperate.fly.mapper.ModelInfoMapper;
import com.cooperate.fly.mapper.PackageInfoMapper;
import com.cooperate.fly.web.util.*;
import com.google.gson.Gson;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.annotation.Validated;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.cooperate.fly.bo.Catalog;
import com.cooperate.fly.bo.User;
import com.cooperate.fly.bo.UserRole;
import com.cooperate.fly.service.model.ModelDesign;
import com.cooperate.fly.service.user.RoleMenuService;
import com.cooperate.fly.service.user.SysMenuService;
import com.cooperate.fly.service.user.UserRoleService;
import com.cooperate.fly.util.Constant;
import com.cooperate.fly.web.util.EasyUITreeNode;
import com.cooperate.fly.web.util.Result;
import com.cooperate.fly.web.util.WebFrontHelper;

@Controller
@RequestMapping("/catalog")
@SessionAttributes(Constant.USER_SESSION_KEY)
public class CatalogController extends BaseController {
	
	@Resource
	private ModelDesign modelDesign;

	@Autowired
	private CatalogMapper catalogMapper;

	@Autowired
	private ModelInfoMapper modelInfoMapper;

	@Autowired
	private PackageInfoMapper packageInfoMapper;
	
	@RequestMapping("/list")
	@ResponseBody
	public List<Catalog> listAll() {
		List<Catalog> catalogs = this.modelDesign.getCatalogNodes();
		return catalogs;
	}
	
	@RequestMapping(value="/add", method=RequestMethod.POST)
	@ResponseBody
	public Result add(String nodeName,int parentId) {
		this.modelDesign.createNoneLeafCatalogNode(nodeName, parentId);
		return new Result();
	}
	
	@RequestMapping(value="/update", method=RequestMethod.POST)
	@ResponseBody
	public Result update(Catalog catalog) {

		this.modelDesign.updateCatalogNode(catalog);
		return new Result();
	}
	
	@RequestMapping(value="/add", method=RequestMethod.GET)
	@ResponseBody
	public Result add(Catalog catalog) {
		switch (catalog.getType()){
			case 0 :
				this.modelDesign.createModelCatalogNode(catalog.getName(), catalog.getParentId());
				break;
			case 1 :
				this.modelDesign.createModelNode(catalog.getName(), catalog.getParentId());
				break;
			case 2 :
				this.modelDesign.createPackageCatalogNode(catalog.getName(), catalog.getParentId());
				break;
			case 3 :
				this.modelDesign.createPackageNode(catalog.getName(), catalog.getParentId());
				break;
			default:				throw new IllegalArgumentException("非法的类型");
		}
		return new Result();
	}
	
	@RequestMapping(value="/update", method=RequestMethod.GET)
	@ResponseBody
	public Result update(Catalog catalog) {

		//只修改名字
		this.modelDesign.updateCatalogNode(catalog);
		int type = catalog.getType();
		if(type == 1) {//model
			ModelInfo modelInfo = modelInfoMapper.selectByPrimaryKey(catalog.getId());
			modelInfo.setName(catalog.getName());
			modelInfoMapper.updateByPrimaryKey(modelInfo);
		}
		else if(type == 3) { //package
			PackageInfo packageInfo = packageInfoMapper.selectByPrimaryKey(catalog.getId());
			packageInfo.setName(catalog.getName());
			packageInfoMapper.updateByPrimaryKey(packageInfo);
		}
		return new Result();
	}
	
	@RequestMapping(value="/delete")
	@ResponseBody
	public Result delete(@RequestParam(value="catalogId", required=true) int catalogId) {
		//TODO 递归删除
		Catalog catalog = catalogMapper.selectByPrimaryKey(catalogId);
		int type = catalog.getType();
		this.modelDesign.deleteCatalogNode(catalogId);
		if(type == 1)//model
			modelInfoMapper.deleteByPrimaryKey(catalogId);
		else if(type == 3) //package
			packageInfoMapper.deleteByPrimaryKey(catalogId);
		return new Result();
	}
	
	@RequestMapping(value = "/tree", produces = "application/json;charset=utf-8")
	@ResponseBody
	public String tree(){
		List<Catalog> catalogs=modelDesign.getCatalogNodes();
		CatalogNode root=WebFrontHelper.buildTreeForEasyuiTreeCataLog(catalogs);
		//PackageDesignNode pkRoot=WebFrontHelper.buildTreeForEasyuiTreePackage(Constant.getPackageDesigns());
		return new Gson().toJson(root.getChildren());
	}
}
