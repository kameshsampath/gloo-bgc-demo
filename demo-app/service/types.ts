export type Data = {
  color: string,
  count: number,
  greeting: string,
  pod: string,
  textColor: string,
  userAgent: string,
}

export type MessageData = {
  message: Data,
  isLoading?: boolean,
  isError?: boolean
}
