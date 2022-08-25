using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SQLite;
using System.Data;
using System.Data.Common;
using Models;
using System.Configuration;

namespace DAL
{
    public class SQLiteHelper
    {
        /// <summary>
        /// ConnectionString样例：Data Source=Test.db3;Pooling=true;FailIfMissing=false
        /// </summary>
        

        private static string ConnectionString = ConfigurationManager.ConnectionStrings["tsddb"].ConnectionString;
        private static void PrepareCommand(SQLiteCommand cmd, SQLiteConnection conn, string cmdText, params object[] p)
        {
            if (conn.State != ConnectionState.Open)
                conn.Open();
            cmd.Parameters.Clear();
            cmd.Connection = conn;
            cmd.CommandText = cmdText;
            cmd.CommandType = CommandType.Text;
            cmd.CommandTimeout = 30;
            if (p != null)
            {
                foreach (object parm in p)
                    cmd.Parameters.AddWithValue(string.Empty, parm);
            }
        }

        public static DataSet ExecuteQuery(string cmdText, params object[] p)
        {
            using (SQLiteConnection conn = new SQLiteConnection(ConnectionString))
            {
                using (SQLiteCommand command = new SQLiteCommand())
                {
                    DataSet ds = new DataSet();
                    PrepareCommand(command, conn, cmdText, p);
                    SQLiteDataAdapter da = new SQLiteDataAdapter(command);
                    da.Fill(ds);
                    return ds;
                }
            }
        }

        public static int ExecuteNonQuery(string cmdText, params object[] p)
        {
            using (SQLiteConnection conn = new SQLiteConnection(ConnectionString))
            {
                using (SQLiteCommand command = new SQLiteCommand())
                {
                    PrepareCommand(command, conn, cmdText, p);
                    return command.ExecuteNonQuery();
                }
            }
        }

        public static SQLiteDataReader ExecuteReader(string cmdText, params object[] p)
        {
            using (SQLiteConnection conn = new SQLiteConnection(ConnectionString))
            {
                using (SQLiteCommand command = new SQLiteCommand())
                {
                    PrepareCommand(command, conn, cmdText, p);
                    return command.ExecuteReader(CommandBehavior.CloseConnection);
                }
            }
        }

        public static object ExecuteScalar(string cmdText, params object[] p)
        {
            using (SQLiteConnection conn = new SQLiteConnection(ConnectionString))
            {
                using (SQLiteCommand command = new SQLiteCommand())
                {
                    PrepareCommand(command, conn, cmdText, p);
                    return command.ExecuteScalar();
                }
            }
        }

        public static User CheckUser(string UserName,string Password)
        {
            try
            {
                string usersql = "select * from users where user_name=@username and password=@pwd";
                SQLiteParameter[] pms = new SQLiteParameter[] {
             new SQLiteParameter("@username",DbType.String) {Value=UserName },new SQLiteParameter("@pwd",DbType.String) {Value=Password }
             };
                DataSet U = ExecuteQuery(usersql, pms);
                if (U.Tables.Count <= 0)
                {
                    throw new Exception("用户名或密码不正确！");
                }
                User User = new User(U.Tables[0].Rows[0][0].ToString(), U.Tables[0].Rows[0][1].ToString(), U.Tables[0].Rows[0][2].ToString());
                return User;
            }
            catch(Exception ex)
            {
                //throw ex;
            }
            finally
            {
                
            }
            return null;
        }

    }
}
