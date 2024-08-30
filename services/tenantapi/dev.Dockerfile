FROM node:20-bookworm-slim AS base

FROM base AS deps
WORKDIR /usr/app
COPY package.json .
COPY .yarnrc.yml .
COPY yarn.lock .
COPY .yarn/plugins .yarn/plugins
COPY .yarn/releases .yarn/releases
COPY types/package.json types/package.json
COPY services/common/package.json services/common/package.json
COPY services/tenantapi/package.json services/tenantapi/package.json
RUN --mount=type=cache,id=node_modules,target=/root/.yarn YARN_CACHE_FOLDER=/root/.yarn \
    yarn workspaces focus @microrealestate/tenantapi

FROM base
WORKDIR /usr/app
COPY --from=deps /usr/app ./
CMD ["yarn", "workspace", "@microrealestate/tenantapi", "run", "dev"]
