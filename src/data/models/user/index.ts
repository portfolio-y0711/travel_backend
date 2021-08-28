import { IDatabaseConnector } from '@app/data/connection'
import { CreateUserTable } from './ddl/create.table'
import { DropUserTable } from './ddl/drop.table'
import { ISchemaAdaptor } from '../../adaptor/index'
import _Promise from 'bluebird'
import { uuidv4 } from '@app/util'

export interface IUserModel extends ISchemaAdaptor {
  save: (user: IUser, userId?: string) => Promise<void>
  remove: () => Promise<void>
  findUsers: () => Promise<IUser[]>
  saveReviewPoint: (userId: string, points: number) => Promise<void>
}

export interface IUser {
  userId?: string
  uuid: string
  name: string
}

export const UserModel = (conn: IDatabaseConnector): IUserModel => {
  const dropSchema = DropUserTable(conn)
  const createSchema = CreateUserTable(conn)
  const findUsers = async () => {
    const db = await conn.getConnection()
    const sql = `SELECT * FROM USERS`
    return new _Promise<IUser[]>((res, rej) => {
      db.all(sql, function (err, result) {
        res(result)
        if (err) {
          console.log('error running sql ' + sql)
        }
      })
    })
  }
  const save = async (user: IUser, userId?: string) => {
    const db = await conn.getConnection()
    const { uuid, name } = user
    const sql = `INSERT INTO USERS VALUES('${userId ?? uuidv4()}','${uuid}','${name}')`
    db.run(sql, function (err) {
      if (err) {
        console.log('error running sql ' + sql)
      }
    })
  }
  const remove = async () => {}
  const saveReviewPoint = async (userId: string, points: number) => {
    return
  }

  return {
    createSchema,
    dropSchema,
    save,
    remove,
    findUsers,
    saveReviewPoint,
  }
}
