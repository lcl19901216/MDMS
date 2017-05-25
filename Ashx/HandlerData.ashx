<%@ WebHandler Language="C#" Class="HandlerData" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Linq;
using Citi.Data;
using Citi.Util;

public class HandlerData : IHttpHandler
{
    string Result = string.Empty;
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        HttpRequest _request = context.Request;
        HttpResponse _response = context.Response;

        string ac = _request["ac"];

        if (!string.IsNullOrEmpty(ac))
        {
            switch (ac)
            {
                case "LoadListData":
                    LoadListData(context);
                    break;
                case "LoadEditData":
                    LoadEditData(context);
                    break;
                case "LoadEditImgData":
                    LoadEditImgData(context);
                    break;
                case "SendMessage":
                    SendMessage(context);
                    break;
                case "SaveEditData":
                    SaveEditData(context);
                    break;
                case "Upload":
                    Upload(context);
                    break;
                case "UploadView":
                    UploadView(context);
                    break;
                case "DownLoadFile":
                    DownLoadFile(context);
                    break;
                case "DelUpLoadFile":
                    DelUpLoadFile(context);
                    break;
            }
        }
        _response.Write(Result);
        _response.End();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    //删除附件
    public void DelUpLoadFile(HttpContext context)
    {
        HttpRequest _request = context.Request;
        Attachment attachment = new Attachment();
        string originname = _request["originname"];
        string pagetype = _request["pagetype"];
        Dictionary<string, string> Dic = new Dictionary<string, string>();
        Dic.Add("originname", originname);
        Dic.Add("pagetype", pagetype);
        Result = attachment.DelUpLoadFile(Dic);
    }

    //下载附件
    public void DownLoadFile(HttpContext context)
    {
        HttpRequest _request = context.Request;
        Attachment attachment = new Attachment();
        string originname = _request["originname"];
        string pagetype = _request["pagetype"];
        string imgnameshort = _request["imgnameshort"];
        string path = HttpContext.Current.Server.MapPath("../xml/upload/" + pagetype);
        path += "\\" + originname;
        IOHandle.DownLoadFile(path, imgnameshort);
    }

    //历史上传的附件
    public void UploadView(HttpContext context)
    {
        HttpRequest _request = context.Request;

        Attachment attachment = new Attachment();
        string filename = _request["filename"];
        string pagetype = _request["pagetype"];
        string attachtype = _request["attachtype"];
        string rowid = _request["rowid"];
        Dictionary<string, string> Dic = new Dictionary<string, string>();
        Dic.Add("filename", filename);
        Dic.Add("pagetype", pagetype);
        Dic.Add("rowid", rowid);
        Dic.Add("attachtype", attachtype);
        Result = attachment.UploadView(Dic);
    }

    //上传附件
    public void Upload(HttpContext context)
    {
        HttpRequest _request = context.Request;
        Attachment attachment = new Attachment();
        string filename = _request["filename"];
        string pagetype = _request["pagetype"];
        string rowid = _request["rowid"];
        string attachtype = _request["attachtype"];
        Dictionary<string, string> Dic = new Dictionary<string, string>();
        Dic.Add("filename", filename);
        Dic.Add("pagetype", pagetype);
        Dic.Add("rowid", rowid);
        Dic.Add("attachtype", attachtype);
        HttpPostedFile files = _request.Files[0];
        Result = attachment.Upload(files, Dic);
    }

    //保存编辑页数据
    public void SaveEditData(HttpContext context)
    {
        HttpRequest _request = context.Request;
        HandleData handledata = new HandleData();
        string SaveResult = _request["SaveResult"];
        SaveResult = HttpUtility.UrlDecode(SaveResult);
        SaveResult = IOHandle.ASCIIToStr(SaveResult);
        string filename = _request["filename"];
        string pagetype = _request["pagetype"];
        string status = _request["status"];
        Result = handledata.SaveEditData(filename, pagetype, status, SaveResult);
    }

    //读取列表页数据
    public void LoadListData(HttpContext context)
    {
        HttpRequest _request = context.Request;
        HandleData handledata = new HandleData();
        string pagetype = _request["pagetype"];
        Result = handledata.LoadListData(pagetype);
    }

    //读取编辑页数据
    public void LoadEditData(HttpContext context)
    {
        HttpRequest _request = context.Request;
        string filename = _request["filename"];
        string pagetype = _request["pagetype"];
        string status = _request["status"];
        HandleData handledata = new HandleData();
        Result = handledata.LoadEditData(filename, status, pagetype);
    }

    //读取编辑页图形数据
    public void LoadEditImgData(HttpContext context)
    {
        HttpRequest _request = context.Request;
        string filename = _request["filename"];
        string pagetype = _request["pagetype"];
        string status = _request["status"];
        HandleData handledata = new HandleData();
        Result = handledata.LoadEditImgData(filename, pagetype, status);
    }

    //长链接搜索
    public void SendMessage(HttpContext context)
    {
        HttpRequest _request = context.Request;
        string filter = _request["filter"];
        filter = filter.Replace("(", @"\(").Replace(")", @"\)").Replace("[", @"\[").Replace("]", @"\]");
        filter = filter.Replace("*", @"(.|\n)*");
        string id = _request["id"];
        HandleData handledata = new HandleData();
        handledata.SearchMessage(filter, id);
    }
}