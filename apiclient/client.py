# -*- coding: utf-8 -*-

# HOSTVM VDI 3.6

from httplib2 import Http
import json

from dataclasses import asdict

from . import types

class Client:
    _host: str
    _rest_url: str
    _auth: str
    _username: str
    _password: str
    _verify_certificate: bool

    _headers: dict = {}

    def __init__(self, host: str, auth: str, username: str, password: str, verify_certificate: bool = False) -> None:
        self._host = host
        self._auth = auth
        self._username = username
        self._password = password
        self._rest_url = 'https://{}/uds/rest/'.format(self._host)
        self._verify_certificate = verify_certificate

    def _request(self, endpoint: str, method: str = 'GET', body: str = ''):
        if not self._verify_certificate:
            h = Http(disable_ssl_certificate_validation=True)
        else:
            h = Http()
        uri = self._rest_url + endpoint
        resp, content = h.request(uri=uri, method=method, body=body, headers=self._headers)
        if resp.status != 200:
            raise Exception('Error {} when requesting uri {}, reason: {}\nResponse: {}'.format(resp.status, uri, resp.reason, content))
        return json.loads(content)

    def login(self):
        '''Аутентификация пользователя'''
        parameters = '{ "auth": "' + self._auth + '", "username": "' + self._username + '", "password": "' + self._password + '" }'
        res = self._request('auth/login', 'POST', parameters)
        if res['result'] != 'ok':  # Authentication error
            raise Exception('Authentication error: {}'.format(res['error']))
        self._headers['X-Auth-Token'] = res['token']
        return

    def logout(self):
        '''Завершение сессии'''
        res = self._request('auth/logout')
        return 'Logout: {}'.format(res['result'])

#Readers

#Providers
    def list_providers(self):
        '''Получение списка провайдеров'''
        return self._request('providers')

    def get_provider(self, provider_id: str):
        '''Получение параметров провайдера'''
        return self._request('providers/{0}'.format(provider_id))

    def list_services(self):
        '''Получение всех базовых сервисов'''
        return self._request('providers/allservices')

    def list_provider_services(self, provider_id: str):
        return self._request('providers/{0}/services'.format(provider_id))

    def get_provider_service(self, provider_id: str, service_id: str):
        '''Получение параметров базового сервиса'''
        return self._request('providers/{0}/services/{1}'.format(provider_id, service_id))

#Authenticators
    def list_auths(self):
        '''Получение списка аутентификаторов'''
        return self._request('authenticators')

    def get_auth(self, auth_id: str):
        '''Получение параметров аутентификатора'''
        return self._request('authenticators/{}'.format(auth_id))

    def list_auth_groups(self, auth_id: str):
        '''Получение списка групп в аутентификаторе'''
        return self._request('authenticators/{}/groups'.format(auth_id))

    def get_auth_group(self, auth_id: str, group_id: str):
        '''Получение параметров группы аутентификатора'''
        return self._request('authenticators/{}/groups/{}'.format(auth_id, group_id))

    def list_auth_users(self, auth_id: str):
        '''Получение списка пользователей в аутентификаторе'''
        return self._request('authenticators/{}/users'.format(auth_id))

    def get_auth_user(self, auth_id: str, user_id: str):
        '''Получение параметров пользователя в аутентификаторе'''
        return self._request('authenticators/{}/users/{}'.format(auth_id, user_id))

    def list_auth_group_users(self, auth_id: str, group_id: str):
        '''Пользователи группы'''
        return self._request('authenticators/{}/groups/{}/users'.format(auth_id, group_id))

#OS Managers
    def list_osmanagers(self):
        '''Получение списка менеджеров ОС'''
        return self._request('osmanagers')

    def get_osmanager(self, osmanager_id: str):
        '''Получение параметров менеджера ОС'''
        return self._request('osmanagers/{}'.format(osmanager_id))

#Transports

    def list_transports(self):
        '''Получение списка созданных транспортов'''
        return self._request('transports')

    def get_transport(self, transport_id: str):
        '''Получение параметров транспорта'''
        return self._request('transports/{}'.format(transport_id))

#Networks

    def list_networks(self):
        '''Получение списка сетей'''
        return self._request('networks')

    def get_network(self, network_id: str):
        '''Получение параметров транспорта'''
        return self._request('networks/{}'.format(network_id))

#Pools
    def list_pools(self):
        '''Получение списка сервис-пулов и их параметров'''
        return self._request('servicespools/overview')

    def get_pool_id(self, name: str):
        '''Получение id сервис-пула по имени'''
        res = self.list_pools()
        for r in res:
            if r['name'] == name:
                return r['id']
        return None

    def get_pool(self, pool_id: str):
        '''Получение параметров сервис-пула'''
        return self._request('servicespools/{}'.format(pool_id))

    def list_pool_groups(self, pool_id: str):
        '''Получение списка добавленных в пул групп'''
        return self._request('servicespools/{}/groups'.format(pool_id))

    def list_pool_transports(self, pool_id: str):
        '''Получение списка добавленных в пул транспортов'''
        return self._request('servicespools/{}/transports'.format(pool_id))

    def list_pool_assigned_services(self, pool_id: str):
        '''Получение списка назначенных пользователям сервисов пула'''
        return self._request('servicespools/{}/services'.format(pool_id))

    def list_pool_cached_services(self, pool_id: str):
        '''Получение списка находящихся в кэше сервисов пула'''
        return self._request('servicespools/{}/cache'.format(pool_id))

    def list_pool_publications(self, pool_id: str):
        '''Получение списка публикаций пула'''
        return self._request('servicespools/{}/publications'.format(pool_id))

    def list_pool_changelog(self, pool_id: str):
        '''Получение журнала изменений публикаций пула'''
        return self._request('servicespools/{}/changelog'.format(pool_id))

    def list_pool_assignables(self, pool_id: str):
        '''Получение списка назначаемых сервисов пула'''
        return self._request('servicespools/{}/listAssignables'.format(pool_id))

#Config

    def get_config(self):
        '''Get system config'''
        return self._request('config')

    def get_permissions(self, cls: str, uuid: str):
        '''Get permissions for an object

        Args:
            cls: object class, valid type is one of the following
                {
                    'providers',
                    'service',
                    'authenticators',
                    'osmanagers',
                    'transports',
                    'networks',
                    'servicespools',
                    'calendars',
                    'metapools',
                    'accounts',
                }
            uuid: object id
        '''
        return self._request('permissions/{}/{}'.format(cls, uuid))

    def list_actor_tokens(self):
        '''Получение списка токенов агента'''
        return self._request('actortokens')

#Writers

#Providers

    def create_static_provider(self, name: str, comments: str='', tags: list=[], config: str='', **kwargs):
        '''Создание сервис-провайдера Static IP Machines'''
        data = {
            'name': kwargs.get('name', name),
            'type': 'PhysicalMachinesServiceProvider',
            'comments': kwargs.get('comments', comments),
            'tags': kwargs.get('tags', tags),
            'config': kwargs.get('config', config),
        }
        return self._request('providers', 'PUT', body=json.dumps(data))

    def create_staticmultiple_service(
        self,
        provider_id: str,
        name: str,
        comments: str='',
        tags: list=[],
        iplist: list=[],
        token: str='',
        port: int=0,
        skipTimeOnFailure: int=0,
        maxSessionForMachine: int=0,
        lockByExternalAccess: bool=False,
        **kwargs
    ):
        '''Создание базового сервиса Static Multiple IP'''
        data = {
            'name': kwargs.get('name', name),
            'type': 'IPMachinesService',
            'comments': kwargs.get('comments', comments),
            'data_type': 'IPMachinesService',
            'tags': kwargs.get('tags', tags),
            'proxy_id': '-1',
            'ipList': kwargs.get('iplist', iplist),
            'token': kwargs.get('token', token),
            'port': kwargs.get('port', port),
            'skipTimeOnFailure': kwargs.get('skipTimeOnFailure', skipTimeOnFailure),
            'maxSessionForMachine': kwargs.get('maxSessionForMachine', maxSessionForMachine),
            'lockByExternalAccess': kwargs.get('lockByExternalAccess', lockByExternalAccess),
        }
        return self._request(
            'providers/{0}/services'.format(provider_id),
            'PUT',
            body=json.dumps(data)
        )

    def create_ovirt_provider(self, name: str, **kwargs):
        '''Создание сервис-провайдера oVirt/RHEV Platform'''
        data = asdict(types.oVirtPlatform(name=name, **kwargs))
        return self._request('providers', 'PUT', body=json.dumps(data))

    def create_ovirtlinked_service(self, provider_id: str, name: str, **kwargs):
        '''Создание базового сервиса oVirt/RHEV Linked Clone'''
        data = asdict(types.oVirtLinkedService(name=name, **kwargs))
        return self._request(
            'providers/{0}/services'.format(provider_id),
            'PUT',
            body=json.dumps(data)
        )

    def create_ovirtfixed_service(self, provider_id: str, name: str, **kwargs):
        '''Создание базового сервиса oVirt/RHEV Fixed Machines'''
        data = asdict(types.oVirtFixedService(name=name, **kwargs))
        return self._request(
            'providers/{0}/services'.format(provider_id),
            'PUT',
            body=json.dumps(data)
        )

#Authenticators

    def create_ad_auth(
        self,
        name: str,
        label: str,
        host: str,
        username: str,
        password: str,
        ldapBase: str,
        comments: str='',
        tags: list=[],
        priority: int=1,
        ssl: bool=False,
        timeout: int=10,
        groupBase: str='',
        defaultDomain: str='',
        nestedGroups: str=False,
        visible: bool=True,
        **kwargs
    ):
        '''Создание аутентификатора Active Directory'''
        data = {
            'name': kwargs.get('name', name),
            'small_name': kwargs.get('small_name', label),
            'host': kwargs.get('host', host),
            'username': kwargs.get('username', username),
            'password': kwargs.get('password', password),
            'ldapBase': kwargs.get('ldapBase', ldapBase),
            'comments': kwargs.get('comments', comments),
            'tags': kwargs.get('tags', tags),
            'priority': kwargs.get('priority', priority),
            'ssl': kwargs.get('ssl', ssl),
            'timeout': str(kwargs.get('timeout', timeout)),
            'groupBase': kwargs.get('groupBase', groupBase),
            'defaultDomain': kwargs.get('defaultDomain', defaultDomain),
            'nestedGroups': kwargs.get('nestedGroups', nestedGroups),
            'data_type': 'ActiveDirectoryAuthenticator',
            'visible': kwargs.get('visible', visible)
        }
        return self._request('authenticators', 'PUT', body=json.dumps(data))

    def create_internal_auth(
        self,
        name: str,
        comments: str,
        tags: list,
        priority: int,
        label: str,
        differentForEachHost: bool,
        reverseDns: bool,
        acceptProxy: bool,
        visible: bool,
        **kwargs
    ):
        '''Создание аутентификатора Internal Database'''
        data = {
            'name': kwargs.get('name', name),
            'comments': kwargs.get('comments', comments),
            'tags': kwargs.get('tags', tags),
            'priority': str(kwargs.get('priority', priority)),
            'small_name': kwargs.get('small_name', label),
            'differentForEachHost': kwargs.get('differentForEachHost', differentForEachHost),
            'reverseDns': kwargs.get('reverseDns', reverseDns),
            'acceptProxy': kwargs.get('acceptProxy', acceptProxy),
            'data_type': 'InternalDBAuth',
            'visible': kwargs.get('visible', visible)
        }
        return self._request('authenticators', 'PUT', body=json.dumps(data))

    def create_regexldap_auth(
        self,
        name: str,
        label: str,
        host: str,
        username: str,
        password: str,
        ldapBase: str,
        comments: str='',
        tags: list=[],
        priority: int=1,
        port: int=389,
        ssl: bool=False,
        timeout: int=10,
        userClass: str='posixAccount',
        userIdAttr: str='uid',
        groupNameAttr: str='cn',
        userNameAttr: str='uid',
        altClass: str='',
        visible: bool=True,
        **kwargs
    ):
        '''Создание аутентификатора Regex LDAP'''
        data = {
            'name': kwargs.get('name', name),
            'small_name': kwargs.get('small_name', label),
            'host': kwargs.get('host', host),
            'username': kwargs.get('username', username),
            'password': kwargs.get('password', password),
            'ldapBase': kwargs.get('ldapBase', ldapBase),
            'comments': kwargs.get('comments', comments),
            'tags': kwargs.get('tags', tags),
            'priority': kwargs.get('priority', priority),
            'port': str(kwargs.get('port', port)),
            'ssl': kwargs.get('ssl', ssl),
            'timeout': str(kwargs.get('timeout', timeout)),
            'userClass': kwargs.get('userClass', userClass),
            'userIdAttr': kwargs.get('userIdAttr', userIdAttr),
            'groupNameAttr': kwargs.get('groupNameAttr', groupNameAttr),
            'userNameAttr': kwargs.get('userNameAttr', userNameAttr),
            'altClass': kwargs.get('altClass', altClass),
            'data_type': 'RegexLdapAuthenticator',
            'visible': kwargs.get('visible', visible)
        }
        return self._request('authenticators', 'PUT', body=json.dumps(data))

    def create_simpleldap_auth(
        self,
        name: str,
        label: str,
        host: str,
        username: str,
        password: str,
        ldapBase: str,
        comments: str='',
        tags: list=[],
        priority: int=1,
        port: int=389,
        ssl: bool=False,
        timeout: int=10,
        userClass: str='posixAccount',
        groupClass: str='posixGroup',
        userIdAttr: str='uid',
        groupIdAttr: str='cn',
        memberAttr: str='memberUid',
        userNameAttr: str='uid',
        visible: bool=True,
        **kwargs
    ):
        '''Создание аутентификатора Simple LDAP'''
        data = {
            'name': kwargs.get('name', name),
            'small_name': kwargs.get('small_name', label),
            'host': kwargs.get('host', host),
            'username': kwargs.get('username', username),
            'password': kwargs.get('password', password),
            'ldapBase': kwargs.get('ldapBase', ldapBase),
            'comments': kwargs.get('comments', comments),
            'tags': kwargs.get('tags', tags),
            'priority': kwargs.get('priority', priority),
            'port': str(kwargs.get('port', port)),
            'ssl': kwargs.get('ssl', ssl),
            'timeout': str(kwargs.get('timeout', timeout)),
            'userClass': kwargs.get('userClass', userClass),
            'groupClass': kwargs.get('groupClass', groupClass),
            'userIdAttr': kwargs.get('userIdAttr', userIdAttr),
            'groupIdAttr': kwargs.get('groupIdAttr', groupIdAttr),
            'memberAttr': kwargs.get('memberAttr', memberAttr),
            'userNameAttr': kwargs.get('userNameAttr', userNameAttr),
            'data_type': 'SimpleLdapAuthenticator',
            'visible': kwargs.get('visible', visible)
        }
        return self._request('authenticators', 'PUT', body=json.dumps(data))

    def create_saml_auth(
        self,
        name: str,
        label: str,
        privateKey: str,
        serverCertificate: str,
        idpMetadata: str,
        userNameAttr: str,
        groupNameAttr: str,
        realNameAttr: str,
        comments: str='',
        tags: list=[],
        priority: int=1,
        entityID: str='',
        usePassword: bool=False,
        pwdAttr: str='',
        visible: bool=True,
        **kwargs
    ):
        '''Создание аутентификатора SAML'''
        data = {
            'name': kwargs.get('name', name),
            'small_name': kwargs.get('small_name', label),
            'privateKey': kwargs.get('privateKey', privateKey),
            'serverCertificate': kwargs.get('serverCertificate', serverCertificate),
            'idpMetadata': kwargs.get('idpMetadata', idpMetadata),
            'userNameAttr': kwargs.get('userNameAttr', userNameAttr),
            'groupNameAttr': kwargs.get('groupNameAttr', groupNameAttr),
            'realNameAttr': kwargs.get('realNameAttr', realNameAttr),
            'comments': kwargs.get('comments', comments),
            'tags': kwargs.get('tags', tags),
            'priority': kwargs.get('priority', priority),
            'entityID': kwargs.get('entityID', entityID),
            'usePassword': kwargs.get('usePassword', usePassword),
            'pwdAttr': kwargs.get('pwdAttr', pwdAttr),
            'data_type': 'SAML20Authenticator',
            'visible': kwargs.get('visible', visible)
        }
        return self._request('authenticators', 'PUT', body=json.dumps(data))

    def create_auth_group(
        self,
        auth_id: str,
        name: str,
        comments: str = '',
        state: str = 'A',
        meta_if_any: bool = False,
        pools: list = [],
        **kwargs
    ):
        '''Добавление группы в аутентификатор'''
        data = {
            'type': 'group',
            'name': kwargs.get('name', name),
            'comments': kwargs.get('comments', comments),
            'state': kwargs.get('state', state),
            'meta_if_any': kwargs.get('meta_if_any', meta_if_any),
            'pools': kwargs.get('pools', pools)
        }
        return self._request(
            'authenticators/{}/groups'.format(auth_id),
            'PUT',
            body=json.dumps(data)
        )

    def create_auth_user(
        self,
        auth_id: str,
        username: str,
        realname: str = '',
        comments: str = '',
        state: str = 'A',
        password: str = '',
        role: str = 'user',
        groups: list = [],
        **kwargs
    ):
        '''Добавление пользователя в аутентификатор'''
        role = kwargs.get('role', role).lower()
        valid_role = {'admin', 'staff', 'user'}
        staff_member = False
        is_admin = False
        if role not in valid_role:
            raise ValueError('Role must be one of: %s' % valid_role)
        if role == 'admin':
            is_admin = True 
            staff_member = True
        elif role == 'staff':
            staff_member = True
        data = {
            'name': kwargs.get('name', username),
            'real_name': kwargs.get('real_name', realname),
            'comments': kwargs.get('comments', comments),
            'state': kwargs.get('state', state),
            'staff_member': staff_member,
            'is_admin': is_admin,
            'groups': kwargs.get('groups', groups),
            'role': role,
        }
        if password or 'password' in kwargs:
            data['password'] = kwargs.get('password', password)
        return self._request(
            'authenticators/{}/users'.format(auth_id),
            'PUT',
            body=json.dumps(data)
        )

#OS Managers

    def create_linux_osmanager(self, name: str, **kwargs):
        '''Создание менеджера ОС Linux'''
        data = asdict(types.LinuxManager(name=name, **kwargs))
        return self._request('osmanagers', 'PUT', body=json.dumps(data))

    def create_linrandom_osmanager(self, name: str, **kwargs):
        '''Создание менеджера ОС Linux Random Password'''
        data = asdict(types.LinRandomPasswordManager(name=name, **kwargs))
        return self._request('osmanagers', 'PUT', body=json.dumps(data))

    def create_windows_osmanager(self, name: str, **kwargs):
        '''Создание менеджера ОС Windows Basic'''
        data = asdict(types.WindowsManager(name=name, **kwargs))
        return self._request('osmanagers', 'PUT', body=json.dumps(data))

    def create_winrandom_osmanager(self, name: str, **kwargs):
        '''Создание менеджера ОС Windows Random Password'''
        data = asdict(types.WinRandomPasswordManager(name=name, **kwargs))
        return self._request('osmanagers', 'PUT', body=json.dumps(data))

    def create_windomain_osmanager(self, name: str, **kwargs):
        '''Создание менеджера ОС Windows Domain'''
        data = asdict(types.WinDomainManager(name=name, **kwargs))
        return self._request('osmanagers', 'PUT', body=json.dumps(data))

#Transports

    # def create_transport(
    #     self,
    #     name: str,
    #     trans_type: str,
    #     tags: list = [],
    #     comments: str = '',
    #     priority: int = 1,
    #     nets_positive: bool = True,
    #     label: str = '',
    #     networks: list = [],
    #     allowed_oss: list = [],
    #     pools: list = [],
    #     **kwargs
    # ):
    #     '''Create transport
        
    #     Args:
    #         trans_type - transport type, valid values are:
    #             HTML5RATransport
    #             HTML5RDPTransport
    #             PCoIPTransport
    #             RATransport
    #             TRATransport
    #             RDPTransport
    #             TSRDPTransport
    #             SPICETransport
    #             TSSPICETransport
    #             URLTransport
    #             X2GOTransport
    #             TX2GOTransport
        
    #     **kwargs
    #         keyword arguments, transport type dependent
    #     '''
    #     data = {}
    #     return self._request(
    #         'transports',
    #         'PUT',
    #         body=json.dumps(data)
    #     )

    def create_rdpdirect_transport(self, name: str, **kwargs):
        '''Create RDP direct transport'''
        data = asdict(types.RDPTransport(name=name, **kwargs))
        return self._request(
            'transports',
            'PUT',
            body=json.dumps(data)
        )

    def create_rdptunnel_transport(self, name: str, tunnelServer: str, **kwargs):
        '''Create RDP tunnel transport'''
        if not tunnelServer:
            raise ValueError('tunnelServer cannot be empty, valid format is HOST:PORT')
        data = asdict(types.TSRDPTransport(name=name, tunnelServer=tunnelServer, **kwargs))
        return self._request(
            'transports',
            'PUT',
            body=json.dumps(data)
        )

    # def create_x2go_transport(
    #     self,
    #     name: str,
    #     tags: list = [],
    #     comments: str = '',
    #     priority: int = 1,
    #     nets_positive: bool = True,
    #     label: str = '',
    #     networks: list = [],
    #     allowed_oss: list = [],
    #     pools: list = []
    # ):
    #     '''Create X2GO direct transport'''
    #     data = {
    #         'name': name,
    #         'tags': tags,
    #         'comments': comments,
    #         'priority': priority,
    #         'nets_positive': nets_positive,
    #         'label': label,
    #         'networks': networks,
    #         'allowed_oss': allowed_oss,
    #         'pools': pools,
    #         'type': 'X2GOTransport',
    #         # TODO: transport config
    #     }
    #     return self._request(
    #         'transports',
    #         'PUT',
    #         body=json.dumps(data)
    #     )

    def add_transport_networks(self, network_id: str, transport_id: str):
        '''Add network to a transport'''
        data = {'id': network_id}
        content = self._request(
            'transports/{}/networks'.format(transport_id),
            'PUT',
            body=json.dumps(data)
        )
        # print("Successfully added transport {} for network {}".format(transport_id, network_id))
        return

#Pools

    def create_pool(
        self,
        name: str,
        service_id: str,
        osmanager_id: str = None,
        short_name: str = '',
        comments: str = '',
        tags: list = [],
        visible: bool = True,
        image_id: str = '-1',
        pool_group_id: str = '-1',
        calendar_message: str = '',
        allow_users_remove: bool = True,
        allow_users_reset: bool = True,
        ignores_unused: bool = False,
        show_transports: bool = True,
        account_id: str = '-1',
        initial_srvs: int = 0,
        cache_l1_srvs: int = 0,
        cache_l2_srvs: int = 0,
        max_srvs: int = 0,
        **kwargs
    ):
        '''Создание нового пула'''
        image_id = '-1' if kwargs.get('image_id', image_id) is None else str(kwargs.get('image_id', image_id))
        pool_group_id = '-1' if kwargs.get('pool_group_id', pool_group_id) is None else str(kwargs.get('pool_group_id', pool_group_id))
        account_id = '-1' if kwargs.get('account_id', account_id) is None else str(kwargs.get('account_id', account_id))

        data = {
            'name': kwargs.get('name', name),
            'short_name': kwargs.get('short_name', short_name),
            'comments': kwargs.get('comments', comments),
            'tags': kwargs.get('tags', tags),
            'service_id': kwargs.get('service_id', service_id),
            'osmanager_id': kwargs.get('osmanager_id', osmanager_id),
            'image_id': image_id,
            'pool_group_id': pool_group_id,
            'initial_srvs': kwargs.get('initial_srvs', initial_srvs),
            'cache_l1_srvs': kwargs.get('cache_l1_srvs', cache_l1_srvs),
            'cache_l2_srvs': kwargs.get('cache_l2_srvs', cache_l2_srvs),
            'max_srvs': kwargs.get('max_srvs', max_srvs),
            'show_transports': kwargs.get('show_transports', show_transports),
            'visible': kwargs.get('visible', visible),
            'allow_users_remove': kwargs.get('allow_users_remove', allow_users_remove),
            'allow_users_reset': kwargs.get('allow_users_reset', allow_users_reset),
            'ignores_unused': kwargs.get('ignores_unused', ignores_unused),
            'account_id': account_id,
            'calendar_message': kwargs.get('calendar_message', calendar_message)
        }

        return self._request('servicespools','PUT', body=json.dumps(data))

    def delete_pool(self, pool_id: str):
        '''Удаление сервис-пула'''
        # Method MUST be DELETE
        content = self._request('servicespools/{}'.format(pool_id), 'DELETE')
        #print("Correctly deleted {}".format(pool_id))
        return

    def modify_pool(self, pool_id: str, max_services: int):
        '''Изменение параметров пула

        В качестве примера для демонстрации реализовано изменение максимального количества ВРС в пуле
        '''
        # TODO: pool paramaters
        content = self._request('servicespools/{}'.format(pool_id))
        data = json.loads(content)
        data['max_srvs'] = max_services
        return self._request('servicespools/{}'.format(pool_id), 'PUT', body=json.dumps(data))

    def publish_pool(self, pool_id: str):
        '''Публикация пула'''
        return self._request('servicespools/{}/publications/publish'.format(pool_id))

    def add_pool_groups(self, pool_id: str, group_id: str):
        '''Добавление в пул группы доступа'''
        data = {'id': group_id}
        return self._request(
            'servicespools/{}/groups'.format(pool_id),
            'PUT',
            body=json.dumps(data)
        )

    def add_pool_transports(self, pool_id: str, transport_id: str):
        '''Добавление в пул транспорта'''
        data = {'id': transport_id}
        return self._request(
            'servicespools/{}/transports'.format(pool_id),
            'PUT',
            body=json.dumps(data)
        )

    def assign_pool_service(self, pool_id: str, user_id: str, assignable_id: str):
        '''Assign pool service to a user'''
        data = {
            'user_id': user_id,
            'assignable_id': assignable_id,
        }
        return self._request(
            'servicespools/{}/createFromAssignable'.format(pool_id),
            body=json.dumps(data)
        )

#Config

    def set_permissions(
        self, 
        cls: str, 
        uuid: str, 
        perm_type: str, 
        entity_id: str, 
        perm: int,
        **kwargs
    ):
        '''Set permissions for an object

        Args:
            cls: object class, valid type is one of the following
                {
                    'providers',
                    'service',
                    'authenticators',
                    'osmanagers',
                    'transports',
                    'networks',
                    'servicespools',
                    'calendars',
                    'metapools',
                    'accounts',
                }
            uuid: object id
            perm_type: must be 'users' or 'groups'
            entity_id: user or group id
            perm: permissions
                32 - read
                64 - manage
        '''
        perm_type = kwargs.get('perm_type', perm_type)
        if perm_type not in ['users', 'groups']:
            raise ValueError('Invalid permission type: {}'.format(perm_type))
        
        perms = {
            '32': '1',
            '64': '2'
        }
        data = {'perm': perms.get(str(kwargs.get('perm', perm)), None)}
        if not data['perm']:
            raise ValueError('Invalid permission: {}'.format(kwargs.get('perm', perm)))
            
        return self._request(
            'permissions/{}/{}/{}/add/{}'.format(
                kwargs.get('cls', cls),
                kwargs.get('uuid', uuid),
                perm_type,
                kwargs.get('entity_id', entity_id)
            ), 
            'PUT', 
            body=json.dumps(data)
        )

    def create_actor_token(
        self,
        token: str,
        ip: str,
        hostname: str,
        mac: str, 
        log_level: str = 'ERROR',
        pre_command: str = '',
        post_command: str = '',
        runonce_command: str = '',
        **kwargs
    ):
        '''Create actor token
        
        Args:
            log_level: must be 'DEBUG', 'INFO', 'ERROR' or 'FATAL'
        '''
        levels = {
            'DEBUG': 0,
            'INFO': 1,
            'ERROR': 2,
            'FATAL': 3
        }
        log_level = levels.get(str(kwargs.get('log_level', log_level)), None)
        if not log_level:
            raise ValueError('Invalid log level: {}'.format(kwargs.get('log_level', log_level)))    
        data = {
            'token': kwargs.get('token', token),
            'ip': kwargs.get('ip', ip),
            'hostname': kwargs.get('hostname', hostname),
            'mac': kwargs.get('mac', mac),
            'log_level': log_level,
            'pre_command': kwargs.get('pre_command', pre_command),
            'post_command': kwargs.get('post_command', post_command),
            'runonce_command': kwargs.get('runonce_command', runonce_command)
        }
        return self._request('actortokens', 'PUT', body=json.dumps(data))
