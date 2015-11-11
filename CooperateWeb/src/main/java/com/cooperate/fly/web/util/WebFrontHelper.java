package com.cooperate.fly.web.util;

import java.utils.*

import com.cooperate.fly.bo.*;
import com.cooperate.fly.mapper.DataValueMapper;
import org.springframework.beans.factory.annotation.Autowired;

public class WebFrontHelper {
	
	/**
	 * 创建目录结构树
	 * @param catalogs
	 * @param idsForChecked
	 * @return
	 */
	public static CatalogNode buildTreeForEasyuiTreeCatalog(List<Catalog> catalogs, List<Integer> idsForChecked) {
		
		Map<Integer, CatalogNode> map = new LinkedHashMap<Integer, CatalogNode>();

		CatalogNode root = new CatalogNode();
		root.setId(0);
		root.setText("智能主模型型号");
		map.put(root.getId(), root);
		root.getChildren();
		
		for (Catalog catalog : catalogs) {
			CatalogNode node = new CatalogNode();
			node.setId(catalog.getId());
			node.setText(catalog.getName());
			node.setParentId(catalog.getParentId() < 0 ? 0 : catalog.getParentId());
			node.setAttributes(catalog);
			map.put(node.getId(), node);
		}
		
		for (Map.Entry<Integer, CatalogNode> entry : map.entrySet()) {
			CatalogNode node = entry.getValue();
			
		
			
			if(node.getId() != 0){
				map.get(node.getParentId()).addChild(node);
			}
		}
		
		for (Map.Entry<Integer, CatalogNode> entry : map.entrySet()) {
			CatalogNode node = entry.getValue();
			node.nodeIsLeaf();
		}
				
		if (idsForChecked != null && idsForChecked.size() > 0) {
			for (Map.Entry<Integer, CatalogNode> entry : map.entrySet()) {
				EasyUITreeNode node = entry.getValue();
			
				if (idsForChecked.contains(node.getId())) {
					node.setChecked(true);
				}
			}
		}
		
	
		
		
		return root;
	}
	
	public static CatalogNode buildTreeForEasyuiTreeCatalog(List<Catalog> catalogs) {
		return buildTreeForEasyuiTree(catalogs, null);
	}
	
	
public static PackageDesignNode buildTreeForEasyuiTreePackage(List<PackageDesign> packs, List<String> idsForChecked) {
		
		Map<Integer, PackageDesignNode> map = new LinkedHashMap<Integer, PackageDesignNode>();
		PackageDesignNode root = new PackageDesignNode();
		root.setId(0);
		root.setText("Root");
		map.put(0, root);
		
		for (PackageDesign pack : packs) {
			PackageDesignNode node = new PackageDesignNode();
			node.setId(pack.getId());
			node.setText(pack.getName());
			node.setParentId(pack.getParentId());
			node.setAttributes(pack);
			map.put(node.getId(), node);
		}
		
		for (Map.Entry<Integer, PackageDesignNode> entry : map.entrySet()) {
			PackageDesignNode node = entry.getValue();
			
			if (node.getId()==0) {
				continue;
			}
			
			Integer parentId = node.getParentId();
			
			if (parentId <0) {
				parentId = 0;
			}
			
			map.get(parentId).addChild(node);
		}
		
		
				
		if (idsForChecked != null && idsForChecked.size() > 0) {
			for (Map.Entry<Integer, PackageDesignNode> entry : map.entrySet()) {
				PackageDesignNode node = entry.getValue();
			
				if (idsForChecked.contains(node.getId())) {
					node.setChecked(true);
				}
			}
		}

		return root;
	}
	
	public static PackageDesignNode buildTreeForEasyuiTreePackage(List<PackageDesign> packageDesigns) {
		return buildTreeForEasyuiTreePackage(packageDesigns, null);
	}
	
	
public static SysMenuNode buildTreeForEasyuiTree(List<SysMenu> menus, List<Integer> menuIdsForChecked) {
		
		Map<Integer, SysMenuNode> map = new LinkedHashMap<Integer, SysMenuNode>();
		SysMenuNode root = new SysMenuNode();
		root.setId(0);
		root.setText("Root");
		map.put(0, root);
		
		for (SysMenu menu : menus) {
			SysMenuNode node = new SysMenuNode();
			node.setId(menu.getMenuId());
			node.setText(menu.getMenuName());
			node.setParentId(menu.getParentMenuId());
			node.setAttributes(menu);
			
			map.put(node.getId(), node);
		}
		
		for (Map.Entry<Integer, SysMenuNode> entry : map.entrySet()) {
			SysMenuNode node = entry.getValue();
			
			if (node.getId()==0) {
				continue;
			}
			
			Integer parentId = node.getParentId();
			
			if (parentId <0) {
				parentId = 0;
			}
			
			map.get(parentId).addChild(node);
		}
		
				
		if (menuIdsForChecked != null && menuIdsForChecked.size() > 0) {
			for (Map.Entry<Integer, SysMenuNode> entry : map.entrySet()) {
				SysMenuNode node = entry.getValue();
			
				if (menuIdsForChecked.contains(node.getId())) {
					node.setChecked(true);
				}
			}
		}

		return root;
	}
	
	public static SysMenuNode buildTreeForEasyuiTree(List<SysMenu> menus) {
		return buildTreeForEasyuiTree(menus, null);
	}
	
public static SysMenu buildMenuTree(List<SysMenu> menus) {
		
		Map<Integer, SysMenu> menuMap = new LinkedHashMap<Integer, SysMenu>();
		SysMenu rootMenu = new SysMenu();
		rootMenu.setMenuId(0);
		rootMenu.setMenuName("Root");
		menuMap.put(0, rootMenu);
		
		for (SysMenu menu : menus) {
			menuMap.put(menu.getMenuId(), menu);
		}
		
		for (SysMenu menu : menus) {
			Integer parentMenuId = menu.getParentMenuId();
			if (parentMenuId <0) {
				parentMenuId = 0;
			} 
			
			menuMap.get(parentMenuId).addChild(menu);
		}

		return rootMenu;
	}
	
	/**
	 * 构造数据项的树形结构
	 * @param dataList
	 * @return
	 */
	public static List<PackageData> buildPackageDataTree(List<PackageData> dataList){
		Map<Integer, PackageData> map = new LinkedHashMap<Integer, PackageData>();
		List<PackageData> result = new LinkedList<PackageData>();

		for (PackageData data : dataList) {
			if(data.getParentId() == 0)//根节点
				result.add(data);
			map.put(data.getId(), data);
		}

		for (Map.Entry<Integer, PackageData> entry : map.entrySet()) {
			PackageData node = entry.getValue();
			if(node.getId() != 0){
				PackageData parent = map.get(node.getParentId());
				if (parent != null)
					parent.addChild(node);
			}
		}

		for (Map.Entry<Integer, PackageData> entry : map.entrySet()) {
			PackageData node = entry.getValue();
			node.nodeIsLeaf();
		}

		return result;
	}

    public static List<UserNode> buildUserGrid(List<User> users){
        List<UserNode> userNodes=new ArrayList<UserNode>();
        for(int i=0;i<users.size();i++) {
            UserNode un = new UserNode();
            un.setId(users.get(i).getId());
            un.setUserName(users.get(i).getUserName());

            un.setRoleId((users.get(i).getRoleId())==null?0:(users.get(i).getRoleId()));
            un.setGroupId((users.get(i).getGroupId())==null?0:(users.get(i).getGroupId()));
            userNodes.add(un);
        }
        return userNodes;
    }
}
