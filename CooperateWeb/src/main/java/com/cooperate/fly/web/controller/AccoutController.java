package com.cooperate.fly.web.controller;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import com.cooperate.fly.web.util.*;
import org.apache.log4j.Logger;
import org.apache.taglibs.standard.lang.jstl.test.beans.PublicInterface2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cooperate.fly.bo.Catalog;
import com.cooperate.fly.bo.SysMenu;
import com.cooperate.fly.bo.User;
import com.cooperate.fly.service.model.ModelDesign;
import com.cooperate.fly.service.operator.DataOperate;
import com.cooperate.fly.service.user.RoleMenuService;
import com.cooperate.fly.service.user.SysMenuService;
import com.cooperate.fly.service.user.UserService;
import com.cooperate.fly.util.Constant;
import com.cooperate.fly.web.util.CatalogNode;
import com.cooperate.fly.web.util.EasyUITreeNode;
import com.cooperate.fly.web.util.PackageDesignNode;
import com.cooperate.fly.web.util.Result;
import com.cooperate.fly.web.util.WebFrontHelper;
import com.google.gson.Gson;

@Controller
public class AccoutController {
	
	private static Logger log=Logger.getLogger(AccoutController.class);
	@Resource
	private UserService userService;
	@Resource
	private SysMenuService sysMenuService;
	@Resource
	private RoleMenuService roleMenuService;
	@Resource
	private ModelDesign modelDesign;
	@Resource
	private DataOperate dataOperate;
	/*
	@RequestMapping(value="/hehe",method=RequestMethod.GET)
	@ResponseBody
	public Result hehe(){
		return new Result("hhehe");
	}
	*/
	
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public String loginPage(HttpSession session,Model model){
		User user=(User) session.getAttribute(Constant.USER_SESSION_KEY);
		if(user==null){
			return "login";
		}
		
		//如果roleId为1 那么为系统管理员；
		//如果roleId为2那么为数据区管理员
		//如果roleId为3那么为工程师；
		//如果roleId为4那么为浏览的领导
		
		//数据区管理员进行模型策划
		int roleId=user.getRoleId();
		if(roleId==2){
			List<Catalog> catalogs=modelDesign.getCatalogNodes();
			CatalogNode root=WebFrontHelper.buildTreeForEasyuiTree(catalogs);
			List nodelist=new LinkedList<CatalogNode>();
			nodelist.add(root);
			
			PackageDesignNode pkRoot=WebFrontHelper.buildTreeForEasyuiTree(Constant.getPackageDesigns());
			model.addAttribute("catalogTreeJson", new Gson().toJson(nodelist));
			model.addAttribute("packageDesignTreeJson",new Gson().toJson(pkRoot.getChildren()));
			System.out.println("=========="+pkRoot.getChildren().size()+pkRoot.getChildren().get(0).getText());
			return "model-design";
		}
		else if(roleId==3){
			List<Catalog> catalogs=modelDesign.getCatalogNodes();
			CatalogNode root=WebFrontHelper.buildTreeForEasyuiTree(catalogs);
			List nodelist=new LinkedList<CatalogNode>();
			nodelist.add(root);
			model.addAttribute("catalogTreeJson", new Gson().toJson(nodelist));
			return "operate";
		}else if(roleId==1){
            List<User> userList=userService.findAll();
            List<UserNode> userNodes=WebFrontHelper.buildUserGrid(userList);
            log.info("usersize============"+userList.size());
            model.addAttribute("userJson", new Gson().toJson(userNodes));
            return "user-design";
        }
		
		return "grant-tips";
		/*List<Integer> roleMenuIds=this.roleMenuService.findMenuIdsByRoleId(roleId);
		for(Integer i:roleMenuIds){
			System.out.println(i);
		}
		if (roleMenuIds ==null ||roleMenuIds.size()==0) {
			session.invalidate();
			return "grant-tips";
		}*/
		
		//List<SysMenu> allMenus=this.sysMenuService.findByChildId(roleMenuIds);
		/*List<SysMenu> allMenus=new ArrayList<SysMenu>();
		SysMenu sm1=new SysMenu();
		sm1.setMenuId(2);
		sm1.setMenuName("父菜单");
		sm1.setMenuUrl("/page/menu");
		sm1.setParentMenuId(1);
		
		SysMenu sm2=new SysMenu();
		sm2.setMenuId(3);
		sm2.setMenuName("子菜单");
		sm2.setMenuUrl("/page/role");
		sm2.setParentMenuId(2);
		SysMenu sm3=new SysMenu();
		sm3.setMenuId(4);
		sm3.setMenuName("孙菜单");
		sm3.setMenuUrl("/page/user");
		sm3.setParentMenuId(3);
		
		allMenus.add(sm1);
		allMenus.add(sm2);
		allMenus.add(sm3);
		
		EasyUITreeNode root=WebFrontHelper.buildTreeForEasyuiTree(allMenus);
		
		
		model.addAttribute("treeJson", new Gson().toJson(root.getChildren()));
		
		return "main";*/
	}

	@RequestMapping(value="/login",method=RequestMethod.POST)
	@ResponseBody
	public Result login(@RequestParam(value="userName",required=true) String userName,@RequestParam(value="password",required=true)String password,HttpSession session){
		User user=this.userService.loadUserByUserNameAndPassword(userName, password);
		if(user!=null){
			log.info("登录成功：{}"+user);
			session.setAttribute(Constant.USER_SESSION_KEY, user);
			return new Result();
		}else{
			return new Result("用户名密码不匹配");
		}
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session){
		if(session!=null){
			session.invalidate();
		}
		return "redirect:/";
	}
	
	@RequestMapping("checkSession")
	@ResponseBody
	public Result checkSession(HttpSession session){
		if(session.getAttribute(Constant.USER_SESSION_KEY)!=null){
			return new Result();
		}
		return new Result(false);
	}
}
