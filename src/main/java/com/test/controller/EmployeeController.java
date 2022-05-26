package com.test.controller;

import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.test.dao.EmployeeDao;
import com.test.domain.Employee;

@Controller
public class EmployeeController {

	@Autowired
	private EmployeeDao employeeDao;
	
    @RequestMapping("/employee")
    public String index(Model model) {
        return "employee";
    }
    
    /**
     * 表格查询
     * @param name
     * @param page 起始页
     * @param rows 行数
     * @return
     */
    @ResponseBody
    @RequestMapping("/grid")
    public Map<String,Object> grid(String name,int page, int rows) {
    	Map<String,Object> map = new HashMap<>();
		page=(page-1)*rows; //对应页的起始位置
    	map.put("offset", page);
    	map.put("limit", rows);
    	map.put("name", name);
    	List<Employee> res =  employeeDao.list(map);
    	int total =  employeeDao.count(map);
    	map.put("total",total);//总数
    	map.put("rows",res);//分页数据
    	map.put("code",0);
    	return map;
    }
    
    /**
     * 更新
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value="/upd")
  	public Map<String,Object> upd(Employee employee){
		System.out.println(employee.toString());
    	Map<String,Object> map = new HashMap<String, Object>(); 
    	try {
    		employeeDao.update(employee);
    		map.put("code",1);
		} catch (Exception e) {
			map.put("code",0);
			map.put("msg", e.toString());
		}
      	return map;
  	}
    
    /**
     * 新增
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value="/ins")
	public Map<String,Object> ins(Employee employee){
    	Map<String,Object> map = new HashMap<String, Object>(); 
    	try {
    		employeeDao.save(employee);
    		map.put("code",1);
		} catch (Exception e) {
			map.put("code",0);
			map.put("msg", e.toString());
		}
      	return map;
	}
    
    /**
     * 单行删除
     * @param id
     * @return
     */
    @ResponseBody
	@RequestMapping(value="/del")
	public Map<String,Object> del(Integer id){
		Map<String,Object> map = new HashMap<String, Object>(); 
    	try {
    		employeeDao.remove(id);
    		map.put("code",1);
		} catch (Exception e) {
			map.put("code",0);
			map.put("msg", e.toString());
		}
      	return map;
	}
	
    /**
     * 多行删除
     * @param ids
     * @return
     */
	@ResponseBody
	@RequestMapping(value="/batchDel")
	public Map<String,Object> batchDel(@RequestParam("ids[]") Integer[] ids){
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			employeeDao.batchRemove(ids);
			map.put("code",1);
		} catch (Exception e) {
			map.put("code",0);
			map.put("msg", e.toString());
		}
		return map;
	}
}
