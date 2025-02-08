resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0
    vpc_id        = aws_vpc.vpc.id #requestor
    peer_vpc_id   = local.default_vpc_id #acceptor
    auto_accept = true

    tags = merge(
        var.common_tags,
        var.vpc_peering_tags,
        {
            Name = "${local.resource_name}-default"
        }
    )
}

resource "aws_route" "public_peering_route" {
    count = var.is_peering_required ? 1 : 0
    route_table_id            = aws_route_table.public_route_table.id
    destination_cidr_block    = local.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "private_peering_route" {
    count = var.is_peering_required ? 1 : 0
    route_table_id            = aws_route_table.private_route_table.id
    destination_cidr_block    = local.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "database_peering_route" {
    count = var.is_peering_required ? 1 : 0
    route_table_id            = aws_route_table.database_route_table.id
    destination_cidr_block    = local.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "default_peering_route" {
    count = var.is_peering_required ? 1 : 0
    route_table_id            = data.aws_route_table.main.route_table_id
    destination_cidr_block    = var.vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}