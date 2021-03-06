import createReducer from '../lib/createReducer'

import {
  HEART_REQUEST,
} from '../actions/heartActions'

const incHeart = (protips, id) => {
  if (!protips) { return null }
  const index = protips.findIndex(p => p.heartableId === id)
  if (index === -1) { return protips }

  const heartable = protips[index]
  return [
    ...protips.slice(0, index),
    { ...heartable, hearts: heartable.hearts + 1 },
    ...protips.slice(index + 1),
  ]
}

export default createReducer({
  items: null,
}, {
  [HEART_REQUEST]: ({ payload: { heartableId } }, state) => ({
    items: incHeart(state.items, heartableId),
  }),
})
